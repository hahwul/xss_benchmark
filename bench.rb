# frozen_string_literal: true

require 'json'
require 'open3'
require 'fileutils'
require 'tmpdir'
require 'net/http'
require 'shellwords'

# Number of parallel workers (can be overridden by BENCH_WORKERS environment variable)
PARALLEL_WORKERS = (ENV['BENCH_WORKERS'] || 1).to_i

# Check command line arguments
if ARGV.empty?
  puts 'Usage: bench.rb <CMD1> [CMD2] [CMD3] ...'
  puts 'Example: bench.rb "dalfox url" "dalfox scan"'
  puts ''
  puts 'Commands will be automatically executed for each endpoint with:'
  puts '  - URL: http://localhost:3000/{endpoint}?query='
  puts '  - Output: -o {endpoint}_{cmdIndex}'
  exit 1
end

commands = ARGV.dup

# Create temporary directory for output files
tmp_dir = File.join(Dir.tmpdir, 'bench_results')
FileUtils.mkdir_p(tmp_dir)

# Define endpoints (1-200: 1-100 basic XSS, 101-200 filtered XSS as defined in app.rb)
ENDPOINTS = (1..200).to_a
BASE_URL = 'http://localhost:3000'

# Start Puma server in background with proper configuration
puts '[*] Starting Puma server in background...'
app_pid = spawn('bundle exec puma -C config/puma.rb', chdir: File.dirname(__FILE__), out: File::NULL, err: File::NULL)
Process.detach(app_pid)

# Wait for server to start with health check
def wait_for_server(host = 'localhost', port = 3000, timeout = 30)
  puts '[*] Waiting for server to start...'
  start_time = Time.now

  loop do
    begin
      Net::HTTP.get_response(URI("http://#{host}:#{port}/"))
      puts '[*] Server is ready!'
      return true
    rescue Errno::ECONNREFUSED, Errno::EADDRNOTAVAIL, SocketError
      if Time.now - start_time > timeout
        puts '[!] Timeout waiting for server to start'
        return false
      end
      sleep 0.5
    end
  end
end

unless wait_for_server
  puts '[!] Failed to start server. Exiting.'
  exit 1
end

# Count items in JSON array from file
def count_json_items(file_path)
  return 0 unless File.exist?(file_path)

  content = File.read(file_path).strip
  return 0 if content.empty?

  begin
    # Try to parse as JSON array
    data = JSON.parse(content)
    if data.is_a?(Array)
      data.length
    else
      1
    end
  rescue JSON::ParserError
    # If not valid JSON array, try to count JSON lines (JSONL format)
    lines = content.split("\n").reject(&:empty?)
    count = 0
    lines.each do |line|
      begin
        JSON.parse(line)
        count += 1
      rescue JSON::ParserError
        # Skip invalid lines
      end
    end
    count
  end
end

# Format elapsed time in human-readable format (e.g., "2s", "1m15s")
def format_time(seconds)
  format_seconds = ->(s) {
    rounded = s.round(1)
    rounded % 1 == 0 ? "#{rounded.to_i}s" : "#{rounded}s"
  }

  if seconds >= 60
    minutes = (seconds / 60).to_i
    remaining_seconds = seconds % 60
    "#{minutes}m#{format_seconds.call(remaining_seconds)}"
  else
    format_seconds.call(seconds)
  end
end

# Run command and return detection count and elapsed time
def run_command(cmd, output_file)
  # Remove existing output file
  FileUtils.rm_f(output_file)

  # Run command (suppress output for parallel execution) and measure time
  start_time = Time.now
  system(cmd, out: File::NULL, err: File::NULL)
  elapsed_time = Time.now - start_time

  # Count results
  count = count_json_items(output_file)
  { count: count, time: elapsed_time }
end

# Build full command with URL and output option
def build_command(cmd_prefix, endpoint, cmd_index, tmp_dir)
  url = "#{BASE_URL}/#{endpoint}?query="
  output_file = File.join(tmp_dir, "#{endpoint}_#{cmd_index}.json")
  # Properly escape URL and output file path for shell execution
  escaped_url = Shellwords.escape(url)
  escaped_output = Shellwords.escape(output_file)
  full_cmd = "#{cmd_prefix} #{escaped_url} --format json -o #{escaped_output}"
  [full_cmd, output_file]
end

begin
  # Run all commands for all endpoints in parallel
  # Structure: results[endpoint][cmd_index] = { count: N, time: T }
  results = {}
  totals = Hash.new(0)  # Count of detections (O's) per command
  mutex = Mutex.new
  completed = 0

  # Build list of all tasks (endpoint, cmd_index pairs)
  tasks = []
  ENDPOINTS.each do |endpoint|
    results[endpoint] = {}
    commands.each_with_index do |cmd_prefix, cmd_index|
      cmd_num = cmd_index + 1
      tasks << { endpoint: endpoint, cmd_prefix: cmd_prefix, cmd_num: cmd_num }
    end
  end

  total_tasks = tasks.size
  puts "\n[*] Running benchmarks in parallel (#{PARALLEL_WORKERS} workers, #{total_tasks} tasks)..."
  benchmark_start_time = Time.now

  # Create thread pool and process tasks
  queue = Queue.new
  tasks.each { |task| queue << task }
  # Add sentinel values to signal completion
  PARALLEL_WORKERS.times { queue << nil }

  thread_errors = []
  last_progress_update = 0

  threads = PARALLEL_WORKERS.times.map do
    Thread.new do
      loop do
        task = queue.pop
        break if task.nil? # Sentinel value signals completion

        begin
          endpoint = task[:endpoint]
          cmd_prefix = task[:cmd_prefix]
          cmd_num = task[:cmd_num]

          full_cmd, output_file = build_command(cmd_prefix, endpoint, cmd_num, tmp_dir)
          result = run_command(full_cmd, output_file)

          mutex.synchronize do
            results[endpoint][cmd_num] = result
            totals[cmd_num] += 1 if result[:count] > 0  # Count detections (O's)
            completed += 1
            # Throttle progress updates to every 5% or every 5 tasks
            if completed - last_progress_update >= [total_tasks / 20, 5].min || completed == total_tasks
              progress = (completed.to_f / total_tasks * 100).round(1)
              elapsed = Time.now - benchmark_start_time
              print "\r[*] Progress: #{completed}/#{total_tasks} (#{progress}%) - Elapsed: #{elapsed.round(1)}s"
              $stdout.flush
              last_progress_update = completed
            end
          end
        rescue StandardError => e
          mutex.synchronize { thread_errors << e }
        end
      end
    end
  end

  threads.each(&:join)

  unless thread_errors.empty?
    puts "\n[!] Warning: #{thread_errors.size} task(s) encountered errors during execution"
  end

  benchmark_end_time = Time.now
  total_elapsed_time = benchmark_end_time - benchmark_start_time

  puts "\n[*] Benchmark completed in #{total_elapsed_time.round(2)} seconds"

  # Generate markdown table
  puts "\n[*] Results:"
  puts ''

  # Header row
  header = ['Endpoint'] + commands.each_with_index.map { |cmd, i| "CMD#{i + 1} (#{cmd})" }
  puts "| #{header.join(' | ')} |"
  puts "|#{header.map { '----------' }.join('|')}|"

  # Data rows
  ENDPOINTS.each do |endpoint|
    row = [endpoint.to_s]
    commands.each_with_index do |_, cmd_index|
      cmd_num = cmd_index + 1
      result = results[endpoint][cmd_num]
      status = result[:count] > 0 ? 'O' : 'X'
      time_str = format_time(result[:time])
      row << "#{status} (#{time_str})"
    end
    puts "| #{row.join(' | ')} |"
  end

  # Summary row (totals)
  total_row = ['**Total**']
  commands.each_with_index do |_, cmd_index|
    cmd_num = cmd_index + 1
    total_row << "**#{totals[cmd_num]}**"
  end
  puts "| #{total_row.join(' | ')} |"
  puts ''

  # Print timing summary
  puts "---"
  puts "**Elapsed Time:** #{total_elapsed_time.round(2)} seconds"
  puts "**Parallel Workers:** #{PARALLEL_WORKERS}"
  puts "**Total Tasks:** #{total_tasks}"
  puts ''
ensure
  # Stop Puma server
  puts '[*] Stopping Puma server...'
  begin
    Process.kill('TERM', app_pid)
  rescue Errno::ESRCH
    # Process already terminated
  end

  # Cleanup temporary files (all scan residual files)
  puts '[*] Cleaning up temporary files...'
  FileUtils.rm_rf(tmp_dir)
end

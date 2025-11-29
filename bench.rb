# frozen_string_literal: true

require 'json'
require 'open3'
require 'fileutils'
require 'tmpdir'
require 'net/http'

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

# Define endpoints (1-50 as defined in app.rb)
ENDPOINTS = (1..50).to_a
BASE_URL = 'http://localhost:3000'

# Start app.rb in background
puts '[*] Starting app.rb in background...'
app_pid = spawn('bundle exec ruby app.rb', chdir: File.dirname(__FILE__), out: File::NULL, err: File::NULL)
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

# Run command and return detection count
def run_command(cmd, output_file)
  puts "[*] Running: #{cmd}"

  # Remove existing output file
  FileUtils.rm_f(output_file)

  # Run command
  system(cmd)

  # Count results
  count_json_items(output_file)
end

# Build full command with URL and output option
def build_command(cmd_prefix, endpoint, cmd_index, tmp_dir)
  url = "#{BASE_URL}/#{endpoint}?query="
  output_file = File.join(tmp_dir, "#{endpoint}_#{cmd_index}.json")
  full_cmd = "#{cmd_prefix} #{url} -o #{output_file}"
  [full_cmd, output_file]
end

begin
  # Run all commands for all endpoints
  # Structure: results[endpoint][cmd_index] = count
  results = {}
  totals = Hash.new(0)

  puts "\n[*] Running benchmarks..."
  ENDPOINTS.each do |endpoint|
    results[endpoint] = {}
    commands.each_with_index do |cmd_prefix, cmd_index|
      cmd_num = cmd_index + 1
      full_cmd, output_file = build_command(cmd_prefix, endpoint, cmd_num, tmp_dir)
      count = run_command(full_cmd, output_file)
      results[endpoint][cmd_num] = count
      totals[cmd_num] += count
    end
  end

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
      row << results[endpoint][cmd_num].to_s
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
ensure
  # Stop app.rb
  puts '[*] Stopping app.rb...'
  begin
    Process.kill('TERM', app_pid)
  rescue Errno::ESRCH
    # Process already terminated
  end

  # Cleanup temporary files (all scan residual files)
  puts '[*] Cleaning up temporary files...'
  FileUtils.rm_rf(tmp_dir)
end

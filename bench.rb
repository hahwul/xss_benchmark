# frozen_string_literal: true

require 'json'
require 'open3'
require 'fileutils'
require 'tmpdir'
require 'net/http'

# Check command line arguments
if ARGV.length < 2
  puts 'Usage: bench.rb <CMD1> <CMD2>'
  puts 'Example: bench.rb "dalfox scan http://localhost:3000/10?query= -f json" "nuclei -u http://localhost:3000/10?query= -json"'
  exit 1
end

cmd1 = ARGV[0]
cmd2 = ARGV[1]

# Create temporary directory for output files
tmp_dir = File.join(Dir.tmpdir, 'bench_results')
FileUtils.mkdir_p(tmp_dir)

output_file1 = File.join(tmp_dir, 'result1.json')
output_file2 = File.join(tmp_dir, 'result2.json')

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
  full_cmd = "#{cmd} -o #{output_file}"
  puts "[*] Running: #{full_cmd}"

  # Remove existing output file
  FileUtils.rm_f(output_file)

  # Run command
  system(full_cmd)

  # Count results
  count_json_items(output_file)
end

begin
  # Run commands
  puts "\n[*] Running CMD1..."
  count1 = run_command(cmd1, output_file1)

  puts "\n[*] Running CMD2..."
  count2 = run_command(cmd2, output_file2)

  # Generate markdown table
  puts "\n[*] Results:"
  puts ''
  puts '| Command | Detected |'
  puts '|---------|----------|'
  puts "| CMD1 | #{count1} |"
  puts "| CMD2 | #{count2} |"
  puts ''
ensure
  # Stop app.rb
  puts '[*] Stopping app.rb...'
  begin
    Process.kill('TERM', app_pid)
  rescue Errno::ESRCH
    # Process already terminated
  end

  # Cleanup temporary files
  FileUtils.rm_f(output_file1)
  FileUtils.rm_f(output_file2)
end

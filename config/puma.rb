# frozen_string_literal: true

# Puma configuration for XSS Benchmark server
# Optimized for parallel scanning scenarios

# Rackup file location
rackup 'config.ru'

# Bind to all interfaces on port 3000
bind 'tcp://0.0.0.0:3000'

# Thread configuration for parallel request handling
# Set min/max threads based on environment variables or defaults
# Higher thread counts allow more concurrent requests
min_threads = ENV.fetch('PUMA_MIN_THREADS', 5).to_i
max_threads = ENV.fetch('PUMA_MAX_THREADS', 16).to_i
threads min_threads, max_threads

# Worker configuration (multi-process mode)
# Number of worker processes to run
# Each worker can handle max_threads concurrent requests
# Total concurrent capacity = workers * max_threads
workers ENV.fetch('PUMA_WORKERS', 2).to_i

# Environment
environment ENV.fetch('RACK_ENV', 'development')

# Allow workers to be killed after 60 seconds
worker_timeout 60

# Reduce output noise in benchmark mode
quiet

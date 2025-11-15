$LOAD_PATH.unshift(File.dirname(__FILE__))

require "dotenv"

# Try to load .env file if it exists
env_file = File.join(__dir__, ".env")
if File.exist?(env_file)
  puts "Loading .env from #{env_file}"
  Dotenv.load(env_file)
else
  puts "Note: .env file not found at #{env_file}"
  puts "Using environment variables from Docker/system"
end

# Debug: Print environment on startup
puts "=== OmbiBot Container Startup Debug ==="
puts "Current environment variables:"
ENV.each { |k, v| puts "  #{k}=#{v[0..50]}..." if k.start_with?("SLACK", "OMBI", "PLEX", "PORT", "RACK", "TZ") }
puts "========================================"

require "ombibot"
require "web"

Thread.abort_on_exception = false

# Print versions of async gems (helpful for debugging runtime image)
begin
  require 'rubygems'
  puts "async-websocket: #{Gem.loaded_specs['async-websocket'] && Gem.loaded_specs['async-websocket'].version}"
  puts "async: #{Gem.loaded_specs['async'] && Gem.loaded_specs['async'].version}"
rescue Exception
  puts "Could not determine async gem versions"
end

# Only start the bot if SLACK_API_TOKEN is set
if ENV["SLACK_API_TOKEN"] && !ENV["SLACK_API_TOKEN"].empty?
  Thread.new do
    begin
      OmbiBot::Bot.run
    rescue Exception => e
      STDERR.puts "ERROR starting Slack real-time client: #{e.class} - #{e.message}"
      STDERR.puts e.backtrace.join("\n")
      STDERR.puts "The web server will continue to run. To fix Slack RT, ensure the image includes async-websocket ~> 0.8.0 and async ~> 1.x, or remove SLACK_API_TOKEN to disable the RT client."
      # Do not re-raise here so Puma/web continues running even if the Slack thread fails
    end
  end
else
  puts "WARNING: SLACK_API_TOKEN not set. Slack bot will not run, but web server will be available."
  puts "Set SLACK_API_TOKEN environment variable to enable the bot."
end

run OmbiBot::Web

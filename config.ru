$LOAD_PATH.unshift(File.dirname(__FILE__))

require "dotenv"
Dotenv.load if File.exist?(".env")

# Debug: Print environment on startup
puts "=== OmbiBot Container Startup Debug ==="
puts "Current environment variables:"
ENV.each { |k, v| puts "  #{k}=#{v[0..50]}..." if k.start_with?("SLACK", "OMBI", "PLEX", "PORT", "RACK", "TZ") }
puts "========================================"

require "ombibot"
require "web"

Thread.abort_on_exception = true

# Only start the bot if SLACK_API_TOKEN is set
if ENV["SLACK_API_TOKEN"] && !ENV["SLACK_API_TOKEN"].empty?
  Thread.new do
    begin
      OmbiBot::Bot.run
    rescue Exception => e
      STDERR.puts "ERROR: #{e}"
      STDERR.puts e.backtrace
      raise e
    end
  end
else
  puts "WARNING: SLACK_API_TOKEN not set. Slack bot will not run, but web server will be available."
  puts "Set SLACK_API_TOKEN environment variable to enable the bot."
end

run OmbiBot::Web

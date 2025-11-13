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

Thread.new do
  begin
    OmbiBot::Bot.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run OmbiBot::Web

require "slack-ruby-bot"
require "ombibot/commands/hello"
require "ombibot/commands/request"
require "ombibot/bot"

# Debug: Check if SLACK_API_TOKEN is set
if ENV["SLACK_API_TOKEN"].nil? || ENV["SLACK_API_TOKEN"].empty?
  puts "WARNING: SLACK_API_TOKEN is not set. Bot will fail to initialize."
  puts "Environment variables present:"
  ENV.each { |k, v| puts "  #{k}=#{v[0..20]}..." if k.start_with?("SLACK", "OMBI", "PLEX", "PORT", "RACK", "TZ") }
end

SlackRubyBot.configure do |config|
  config.aliases = ["plex", "plex_request", "ombi"]
end

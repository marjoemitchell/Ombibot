require "slack-ruby-bot"

module OmbiBot
  class Bot < SlackRubyBot::Bot
    help do
      title "Bot for Ombi"
      desc "Im the captain of this pirate shit my dude!"
    end
  end
end

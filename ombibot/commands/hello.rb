module OmbiBot
  module Commands
    class Hello < SlackRubyBot::Commands::Base
      command 'hello', 'sup', 'you dumb robot', 'whats good' do |client, data, _match|
        client.say(text: "Sup bruh. We doing this or what?", channel: data.channel)
      end
    end
  end
end

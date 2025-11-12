module OmbiBot
  module Commands
    class Hello < SlackRubyBot::Commands::Base
      command 'hello', 'sup', 'you dumb robot', 'hi' do |client, data, _match|
        client.say(text: "Sup. We doing this or what?", channel: data.channel)
      end
      command 'let me lick that butt', 'LET ME LICK DAT BUTT', 'lemme lick dat butt', 'lemme lick dat butt' do |client, data, _match|
        client.say(text: "Should we change my name to Ombibotandbuttstuff?", channel: data.channel)
      end
    end
  end
end

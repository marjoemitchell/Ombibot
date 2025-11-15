require "httparty"
require "uri"
require "json"

module OmbiBot
  module Commands
    class Request < SlackRubyBot::Commands::Base
      command "download", "get", "request", "search", "find" do |client, data, match|
  # URI.escape is removed in newer Ruby versions; use encode_www_form_component
        query = URI.encode_www_form_component(match["expression"].to_s)

        # Call Ombi and handle non-JSON or error responses gracefully
        resp = HTTParty.get("#{OMBI_URL}/api/v1/Search/movie/#{query}",
                             headers: { "ApiKey" => OMBI_API_KEY })

        if resp.code != 200
          STDERR.puts "Ombi search HTTP error: #{resp.code} -> #{resp.body[0..500]}"
          client.web_client.chat_postMessage(channel: data.channel,
                                             text: "Ombi search failed (HTTP #{resp.code}). Check Ombi URL and API key.")
          next
        end

        begin
          body = JSON.parse(resp.body)
        rescue JSON::ParserError => e
          STDERR.puts "JSON parse error from Ombi search: #{e.message}; body=#{resp.body[0..500]}"
          client.web_client.chat_postMessage(channel: data.channel,
                                             text: "Ombi returned an unexpected response (not JSON). Check Ombi_URL and OMBI_API_KEY, and ensure Ombi is reachable.")
          next
        end

        build_message = -> {
          {
            channel: data.channel,
            text: "Is this all I'm good for!?!? #{[3, body.size].min} of #{body.size} results for \"#{match["expression"]}\":",
            fallback: "use a full-featured slack client to use OmbiBot",
            attachments: body.first(3).map do |movie|
              {
                title: "#{movie["title"]} (#{movie["releaseDate"][0..3]})",
                thumb_url: "https://image.tmdb.org/t/p/w300/#{movie["posterPath"]}",
                text: movie["overview"][0..200] + "...",
                callback_id: "movie_request",
                actions: [
                  {
                    name: "request",
                    text: "Request #{movie["title"]}",
                    type: "button",
                    value: movie["id"],
                  },
                ],
              }
            end,
          }
        }

        client.web_client.chat_postMessage(build_message.call)
      end
    end
  end
end

require "sinatra/base"
require "uri"
require "httparty"
require "json"

PORT = ENV["PORT"] || 3000
OMBI_URL = ENV["OMBI_URL"]
OMBI_API_KEY = ENV["OMBI_API_KEY"]
OMBI_USER=ENV["OMBI_USER"]

module OmbiBot
  class Web < Sinatra::Base
    set :port, PORT
    get "/" do
      "Math is good for you."
    end
    post "/" do
      # Slack sends an urlencoded form param named `payload` for interactive components.
      # Prefer Sinatra's params parsing; fall back to manual decode if needed.
      raw_payload = params["payload"]
      raw_payload ||= begin
        # legacy fallback: request.body may contain `payload=` prefix
        pb = request.body.read.to_s
        if pb.start_with?("payload=")
          URI.decode_www_form_component(pb[8..-1])
        else
          pb
        end
      end

      begin
        body = JSON.parse(raw_payload)
      rescue JSON::ParserError => e
        STDERR.puts "Failed to parse interactive payload: #{e.message}; raw_payload=#{raw_payload[0..500]}"
        halt 400, "invalid payload"
      end

      type = body["callback_id"]
      if type == "movie_request"
        begin
          req_body = {
            "theMovieDbId" => body["actions"][0]["value"].to_i,
            "languageCode" => "en",
          }.to_json

          res = HTTParty.post(
            "#{OMBI_URL}/api/v1/Request/movie",
            headers: {"ApiKey" => OMBI_API_KEY, "UserName" => OMBI_USER, "Content-Type" => "application/json"},
            body: req_body,
          )

          if res.code != 200 && res.code != 201
            STDERR.puts "Ombi request failed: HTTP #{res.code} -> #{res.body.to_s[0..1000]}"
            # Return a clear message to Slack so you can see the failure in-channel
            return "Ombi request failed (HTTP #{res.code}). See logs for details."
          end

          # Try to return the message field if present, otherwise the full parsed response
          parsed = res.parsed_response
          if parsed.is_a?(Hash) && parsed["message"]
            return parsed["message"]
          else
            return parsed.to_s
          end
        rescue => exception
          STDERR.puts "exception while posting request to Ombi: #{exception.class}: #{exception.message}"
          STDERR.puts exception.backtrace.join("\n")[0..2000]
          return "Ombi request failed due to an internal error. Check container logs."
        end
      end
      status 204
    end
  end
end

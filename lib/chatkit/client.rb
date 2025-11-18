# frozen_string_literal: true

module ChatKit
  # Client for interacting with the ChatKit service.
  class Client
    module OpenAI
      HOST = "https://api.openai.com"
    end

    # @!attribute [rw] api_key
    #  @return [String] The API key for authenticating requests.
    attr_accessor :api_key

    # @!attribute [rw] host
    #  @return [String] The host URL for the ChatKit service.
    attr_accessor :host

    # @param api_key [String, nil] - optional - The API key for authenticating requests.
    # @param host [String] - optional - The host URL for the ChatKit service.
    def initialize(api_key: ChatKit.configuration.api_key, host: ChatKit.configuration.host)
      @api_key = api_key
      @host = host
    end

    # @return [Net::HTTP]
    def connection
      @connection ||= begin
        http = HTTP.persistent(@host)
        http = http.auth("Bearer #{@api_key}") if @api_key

        http
      end
    end
  end
end

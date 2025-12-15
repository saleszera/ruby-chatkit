# frozen_string_literal: true

module ChatKit
  # Configuration class for ChatKit.
  class Config
    # @!attribute [rw] api_key
    #   @return [String] The API key for authenticating requests.
    attr_accessor :api_key

    # @!attribute [rw] host
    #   @return [String] The host URL for the Chatkit service.
    attr_accessor :host

    # @!attribute [rw] timeout
    #   @return [Integer, nil] The timeout for requests.
    attr_accessor :timeout

    # @param api_key [String] The OpenAi API key.
    # @param host [String] The host URL for the Chatkit service.
    def initialize(api_key: ENV.fetch("OPENAI_API_KEY", nil), host: Client::OpenAI::HOST, timeout: nil)
      @api_key = api_key
      @host = host
      @timeout = timeout
    end
  end
end

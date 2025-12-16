# frozen_string_literal: true

module ChatKit
  class ConversationError < ChatKit::Error; end

  # Represents a conversation with ChatKit.
  #
  # Usage:
  #  ChatKit.configure do |config|
  #    config.client_secret = "your_client_secret"
  #  end
  #
  #  ChatKit::Session.create!(
  #    user_id: "user_12345",
  #    workflow: { id: "wf_68eeb857eaf8819089eb55d32f39a822050622537973ef99" }
  #  )
  #
  #  ChatKit::Conversation.send_message!(
  #    client_secret: ChatKit.current_info.session.client_secret,
  #    text: "Hello, ChatKit!"
  #  )
  class Conversation
    module Defaults
      PAYLOAD = {
        params: {
          input: {
            content: [],
            quote_text: "",
            attachments: [],
            inference_options: {},
          },
        },
      }.freeze
    end

    # @!attribute [rw] text
    #  @return [String]
    attr_accessor :text

    # @!attribute [rw] client_secret
    #  @return [String]
    attr_accessor :client_secret

    # @!attribute [rw] attachments
    #  @return [Array<String>]
    attr_accessor :attachments

    # @!attribute [rw] response
    #  @return [Response]
    attr_accessor :response

    # @param client_secret [String] The client secret for authentication.
    # @param text [String] The text to send in the conversation.
    # @param thread_id [String, nil] - optional - The ID of the thread to continue.
    # @param attachments [Array<String>] The attachments to include in the message.
    # @param client [ChatKit::Client] The ChatKit client instance.
    def initialize(client_secret:, text:, attachments: nil, client: Client.new, logger: nil)
      @client = client
      @client_secret = client_secret
      @text = text
      @attachments = attachments
      @response = Response.new
      @logger = logger
    end

    class << self
      def send_message!(client_secret:, text:, attachments: nil, client: Client.new, logger: nil)
        new(
          client_secret:,
          text:,
          attachments:,
          client:,
          logger:
        ).perform_request!
      end
    end

    # Performs the conversation request.
    # @return [Response] The response object containing the conversation response.
    def perform_request!
      payload = build_payload

      @logger&.info("Starting conversation with payload: #{payload}")

      result = @client.connection.headers(conversation_headers).post(
        conversation_endpoint,
        json: payload
      )

      stream!(result) do |chunk|
        @response.parse!(chunk)
      end

      self
    rescue StandardError => e
      raise ConversationError, "Conversation failed: #{e.message}"
    ensure
      ChatKit.current_info.conversation = self
    end

  private

    # Builds the payload for the conversation request.
    # @return [Hash] The payload hash.
    def build_payload
      raise ArgumentError, "Text must be a non-empty string" if @text.nil? || !@text.is_a?(String) || @text.strip.empty?

      payload = Defaults::PAYLOAD.dup

      payload[:params][:input][:content] << { type: "input_text", text: @text }
      payload[:params][:input][:attachments] = @attachments if @attachments

      if current_thread&.id
        payload[:type] = "threads.add_user_message"
        payload[:params][:thread_id] = current_thread.id
      else
        payload[:type] = "threads.create"
      end

      payload
    end

    # Performs the streaming of the conversation response.
    # @param result [Object] The result object from the HTTP request.
    # @yield [chunk] Yields each chunk of the stream.
    #  @return [void]
    def stream!(result, &)
      Stream.new(result, @logger).stream!(&)
    end

    # Returns the conversation endpoint URL.
    # @return [String] The conversation endpoint.
    def conversation_endpoint
      Request::Endpoints.conversation_endpoint
    end

    # Returns the headers for the conversation request.
    # @return [Hash] The headers hash.
    def conversation_headers
      raise SessionError, "No active session found" unless @client_secret

      Request::Headers.conversation_header.merge(
        "Authorization" => "Bearer #{@client_secret}"
      )
    end

    # Returns the current conversation thread from ChatKit's current info.
    # @return [ChatKit::Conversation::Response::Thread, nil] The current thread
    def current_thread
      ChatKit.current_info.conversation&.response&.thread
    end
  end
end

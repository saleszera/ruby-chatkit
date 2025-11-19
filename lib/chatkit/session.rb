# frozen_string_literal: true

require "json"

# Manage ChatKit sessions, threads, and file uploads for internal integrations.
module ChatKit
  # Represents a ChatKit session.
  #
  # Source: https://platform.openai.com/docs/api-reference/chatkit/sessions/create
  # Usage:
  #  ChatKit.configure do |config|
  #    config.client_secret = "your_client_secret"
  #  end
  #
  #  ChatKit::Session.create!(
  #    user_id: "user_12345",
  #    workflow: { id: "wf_68eeb857eaf8819089eb55d32f39a822050622537973ef99" }
  #  )
  class Session
    module Defaults
      ENABLED = true
    end

    # @!attribute [r] client
    #  @return [Ruby::ChatKit::Client] The ChatKit client instance.
    attr_accessor :client

    # @!attribute [r] user_id
    #  @return [String] The ID of the user.
    attr_accessor :user_id

    # @!attribute [r] workflow
    #  @return [Workflow] The workflow for the session.
    attr_accessor :workflow

    # @!attribute [r] chatkit_configuration
    #  @return [ChatKitConfiguration] The ChatKit configuration.
    attr_accessor :chatkit_configuration

    # @!attribute [r] expires_after
    #  @return [ExpiresAfter] The expiration time for the session.
    attr_accessor :expires_after

    # @!attribute [r] rate_limits
    #  @return [RateLimits] The rate limits for the session.
    attr_accessor :rate_limits

    # @param workflow [Hash] The ID of the session.
    # @param user_id [String] The ID of the user.
    # @param chatkit_configuration [Hash, nil] - optional - The ChatKit configuration.
    # @param expires_after [Hash, nil] - optional - The expiration time for the session.
    # @param rate_limits [Hash, nil] - optional - The rate limits for the session.
    # @param client [Ruby::ChatKit::Client] The ChatKit client instance.
    def initialize(
      user_id:,
      workflow:,
      chatkit_configuration: nil,
      expires_after: nil,
      rate_limits: nil,
      client: Client.new
    )
      @client = client
      @user_id = user_id
      @workflow = Workflow.build(**workflow.to_h)
      @chatkit_configuration = ChatKitConfiguration.build(**chatkit_configuration.to_h)
      @expires_after = ExpiresAfter.build(**expires_after) if expires_after.is_a?(Hash)
      @rate_limits = RateLimits.build(**rate_limits.to_h)
    end

    class << self
      def create!(
        user_id:,
        workflow:,
        chatkit_configuration: nil,
        expires_after: nil,
        rate_limits: nil,
        client: Client.new
      )
        new(
          user_id:,
          workflow:,
          chatkit_configuration:,
          expires_after:,
          rate_limits:,
          client:
        ).create!
      end
    end

    # Creates a new ChatKit session.
    # @return [Response] The created session data.
    def create!
      payload = build_payload
      response = perform_request(payload)

      handle_response_errors(response)

      session_response = parse_response(response)

      update_current_session(session_response)
    end

  private

    # @return [Hash]
    def build_payload
      {
        user: user_id,
        workflow: workflow.serialize,
        chatkit_configuration: chatkit_configuration.serialize,
        expires_after: expires_after&.serialize,
        rate_limits: rate_limits.serialize,
      }.compact
    end

    # Performs the HTTP request to create a session.
    #
    # @param payload [Hash] The request payload.
    # @return [Net::HTTPResponse] The HTTP response.
    def perform_request(payload)
      @client.connection.headers(sessions_header).post(sessions_endpoint, json: payload)
    end

    # Handles HTTP response errors by raising appropriate exceptions.
    #
    # @param response [Net::HTTPResponse] The HTTP response to check.
    # @raise [ChatKitError] If the response indicates an error.
    def handle_response_errors(response)
      return unless response.code >= 300

      error_class = ChatKitError.set_error("Session", "Session creation failed with status #{response.code}")
      raise error_class, "#{response.code}: #{response.body}"
    end

    # Parses the HTTP response body.
    #
    # @param response [Net::HTTPResponse] The HTTP response to parse.
    # @return [Hash] The parsed response body.
    def parse_response(response)
      Response.deserialize(response.parse)
    end

    # Updates the current session with the provided data.
    #
    # @param data [Hash] The session data to store.
    # @return [Response] The updated current session.
    def update_current_session(session_response)
      ChatKit.current_info.session = session_response
    end

    # @param response [Net::HTTPResponse] The HTTP response to parse.
    #  @return [Hash] The parsed response body.
    def parse!(response)
      Response.deserialize(response.parse)
    end

    # @return [String] The endpoint URL for sessions.
    def sessions_endpoint
      Request::Endpoints.sessions_endpoint
    end

    # @return [Hash] The headers for session requests.
    def sessions_header
      Request::Headers.sessions_header
    end
  end
end

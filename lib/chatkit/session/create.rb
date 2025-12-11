# frozen_string_literal: true

module ChatKit
  class Session
    # Represents the creation of a ChatKit session.
    # source: https://platform.openai.com/docs/api-reference/chatkit/sessions/create
    class Create
      class SessionCreateError < StandardError; end

      # @!attribute [rw] user_id
      #  @return [String] The ID of the user.
      attr_accessor :user_id

      # @!attribute [rw] workflow
      #  @return [Workflow] The workflow for the session.
      attr_accessor :workflow

      # @!attribute [rw] chatkit_configuration
      #  @return [ChatKitConfiguration] The ChatKit configuration.
      attr_accessor :chatkit_configuration

      # @!attribute [rw] expires_after
      #  @return [ExpiresAfter] The expiration time for the session.
      attr_accessor :expires_after

      # @!attribute [rw] rate_limits
      #  @return [RateLimits] The rate limits for the session.
      attr_accessor :rate_limits

      # @!attribute [rw] response
      #  @return [Response] The session response data.
      attr_accessor :response

      # @param user_id [String] The ID of the user.
      # @param workflow [Hash] The ID of the session.
      # @param chatkit_configuration [Hash, nil] - optional - The ChatKit configuration.
      # @param expires_after [Hash, nil] - optional - The expiration time for the session.
      # @param rate_limits [Hash, nil] - optional - The rate limits for the session.
      # @param session_id [String, nil] - optional - The ID of the session.
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
        @workflow = Session::Workflow.build(**workflow.to_h)
        @chatkit_configuration = Session::ChatKitConfiguration.build(**chatkit_configuration.to_h)
        @expires_after = Session::ExpiresAfter.build(**expires_after) if expires_after.is_a?(Hash)
        @rate_limits = Session::RateLimits.build(**rate_limits.to_h)
      end

      class << self
        def call(
          user_id:,
          workflow:,
          chatkit_configuration: nil,
          expires_after: nil,
          rate_limits: nil,
          client: Client.new
        )
          new(user_id:, workflow:, chatkit_configuration:, expires_after:, rate_limits:, client:).call
        end
      end

      # Executes the Create Session operation.
      #
      # @raise [SessionCreateError] If the session creation fails.
      # @return [Session::Create] The created session instance.
      def call
        payload = build_payload
        response = perform_request(payload)

        handle_response_errors(response)

        @response = parse_response(response)

        self
      rescue StandardError => e
        raise SessionCreateError, "Session creation failed: #{e.message}"
      end

      def refresh!
        call
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
        @client.connection.headers(sessions_header).post(create_session_endpoint, json: payload)
      end

      # Handles HTTP response errors by raising appropriate exceptions.
      #
      # @param response [Net::HTTPResponse] The HTTP response to check.
      # @raise [SessionError] If the response indicates an error.
      def handle_response_errors(response)
        return unless response.code >= 300

        error_message = begin
          response.parse["error"]["message"]
        rescue StandardError
          "Unknown error occurred"
        end

        raise SessionError, error_message
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
      def create_session_endpoint
        Request::Endpoints.create_session_endpoint
      end

      # @return [Hash] The headers for session requests.
      def sessions_header
        Request::Headers.sessions_header
      end
    end
  end
end

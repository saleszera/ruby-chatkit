# frozen_string_literal: true

module ChatKit
  class Session
    # Represents the Cancel Session operation.
    # source: https://platform.openai.com/docs/api-reference/chatkit/sessions/cancel
    class Cancel
      class CancelError < StandardError; end

      # @param session_id [String] The ID of the session to cancel.
      # @param client [Ruby::ChatKit::Client, nil] - optional - The ChatKit client instance.
      def initialize(session_id:, client: Client.new)
        @session_id = session_id
        @client = client
      end

      class << self
        # @param session_id [String] The ID of the session to cancel.
        def call(session_id:, client: Client.new)
          new(session_id:, client:).call
        end
      end

      # Executes the Cancel Session operation.
      # @return [Cancel::Response] The response object.
      def call
        perform_request
      end

    private

      # Performs the HTTP request to create a session.
      #
      # @param payload [Hash] The request payload.
      # @return [Net::HTTPResponse] The HTTP response.
      def perform_request
        response = @client.connection.headers(sessions_header).post(cancel_session_endpoint)

        raise CancelError, "Failed to cancel session: #{response.status}" unless response.status.success?

        Response.deserialize(response.parse)
      end

      # @return [String] The endpoint URL for sessions.
      def cancel_session_endpoint
        Request::Endpoints.cancel_session_endpoint({ id: @session_id })
      end

      # @return [Hash] The headers for session requests.
      def sessions_header
        Request::Headers.sessions_header
      end
    end
  end
end

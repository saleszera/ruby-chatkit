# frozen_string_literal: true

module ChatKit
  class Session
    # Optional override for session expiration timing in seconds from creation. Defaults to 10 minutes.
    #
    # Source: https://platform.openai.com/docs/api-reference/chatkit/sessions/create#chatkit_sessions_create-expires_after
    class ExpiresAfter
      # @!attribute [r] anchor
      # @return [String]
      attr_accessor :anchor

      # @!attribute [r] seconds
      # @return [Integer]
      attr_accessor :seconds

      # @param anchor [String] - required - Base timestamp used to calculate expiration.
      # @param seconds [Integer] - required - Number of seconds after the anchor when the session expires.
      def initialize(anchor:, seconds:)
        @anchor = anchor
        @seconds = seconds
      end

      class << self
        def build(anchor:, seconds:)
          new(anchor:, seconds:)
        end
      end

      # @return [Hash]
      def serialize
        {
          anchor:,
          seconds:,
        }.compact
      end
    end
  end
end

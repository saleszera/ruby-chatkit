# frozen_string_literal: true

module ChatKit
  class Session
    # Optional override for per-minute request limits. When omitted, defaults to 10.
    #
    # Source: https://platform.openai.com/docs/api-reference/chatkit/sessions/create#chatkit_sessions_create-rate_limits
    class RateLimits
      module Defaults
        MAX_REQUESTS_PER_1_MINUTE = 10
      end

      # @!attribute [r] enabled
      #  @return [Integer, nil]
      attr_accessor :max_requests_per_1_minute

      # @param max_requests_per_1_minute [Integer, nil] - optional - Maximum number of requests allowed per 1 minute.
      def initialize(max_requests_per_1_minute: Defaults::MAX_REQUESTS_PER_1_MINUTE)
        @max_requests_per_1_minute = max_requests_per_1_minute
      end

      class << self
        def build(max_requests_per_1_minute: nil)
          new(max_requests_per_1_minute:)
        end

        # @param data [Hash, nil]
        #  @return [RateLimits]
        def deserialize(data)
          new(
            max_requests_per_1_minute: data&.dig("max_requests_per_1_minute")
          )
        end
      end

      # @return [Hash]
      def serialize
        {
          max_requests_per_1_minute:,
        }.compact
      end
    end
  end
end

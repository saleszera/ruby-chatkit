# frozen_string_literal: true

module ChatKit
  class Session
    class Cancel
      # Represents the response from cancel session.
      class Response < Session::BaseResponse
        # @!attribute [rw] cancelled_at
        #   @return [String]
        attr_accessor :cancelled_at

        # @!attribute [rw] scope
        #   @return [Scope, nil]
        attr_accessor :scope

        # @!attribute [rw] ttl_seconds
        #   @return [Integer, nil]
        attr_accessor :ttl_seconds

        # @param cancelled_at [String] The cancellation time.
        def initialize(cancelled_at:, scope:, ttl_seconds:, **kwargs)
          super(**kwargs)

          @cancelled_at = cancelled_at
          @scope = scope
          @ttl_seconds = ttl_seconds
        end

        class << self
          def deserialize(data)
            chatkit_configuration = Session::ChatKitConfiguration.deserialize(data&.dig("chatkit_configuration"))
            rate_limits = Session::RateLimits.deserialize(data&.dig("rate_limits"))
            scope = Scope.deserialize(data&.dig("scope"))
            workflow = Session::Workflow.deserialize(data&.dig("workflow"))

            new(
              id: data&.dig("id"),
              object: data&.dig("object"),
              status: data&.dig("status"),
              client_secret: data&.dig("client_secret"),
              expires_at: data&.dig("expires_at"),
              max_requests_per_1_minute: data&.dig("max_requests_per_1_minute"),
              user: data&.dig("user"),
              ttl_seconds: data&.dig("ttl_seconds"),
              cancelled_at: data&.dig("cancelled_at"),
              chatkit_configuration:,
              rate_limits:,
              scope:,
              workflow:
            )
          end
        end
      end
    end
  end
end

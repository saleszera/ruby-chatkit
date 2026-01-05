# frozen_string_literal: true

module ChatKit
  class Session
    # Represents a session response.
    class BaseResponse
      # @!attribute [r] id
      #  @return [String]
      attr_accessor :id

      # @!attribute [r] object
      #  @return [String]
      attr_accessor :object

      # @!attribute [r] status
      #  @return [String]
      attr_accessor :status

      # @!attribute [r] chatkit_configuration
      #  @return [ChatKitConfiguration]
      attr_accessor :chatkit_configuration

      # @!attribute [r] client_secret
      #  @return [String]
      attr_accessor :client_secret

      # @!attribute [r] expires_at
      #  @return [String]
      attr_accessor :expires_at

      # @!attribute [r] max_requests_per_1_minute
      #  @return [Integer]
      attr_accessor :max_requests_per_1_minute

      # @!attribute [r] rate_limits
      #  @return [RateLimits]
      attr_accessor :rate_limits

      # @!attribute [r] user
      #  @return [Hash]
      attr_accessor :user

      # @!attribute [r] workflow
      #  @return [Workflow]
      attr_accessor :workflow

      # @param id [String] The session ID.
      # @param object [String] The object type.
      # @param status [String] The session status.
      # @param chatkit_configuration [ChatKitConfiguration] The ChatKit configuration.
      # @param client_secret [String] The client secret.
      # @param expires_at [String] The expiration time of the session.
      # @param max_requests_per_1_minute [Integer] The maximum requests allowed per minute.
      # @param rate_limits [RateLimits] The rate limits for the session.
      # @param user [Hash] The user information.
      # @param workflow [Workflow] The workflow for the session.
      def initialize(
        id:,
        object:,
        status:,
        chatkit_configuration:,
        client_secret:,
        expires_at:,
        max_requests_per_1_minute:,
        rate_limits:,
        user:,
        workflow:
      )
        @id = id
        @object = object
        @status = status
        @chatkit_configuration = chatkit_configuration
        @client_secret = client_secret
        @expires_at = expires_at
        @max_requests_per_1_minute = max_requests_per_1_minute
        @rate_limits = rate_limits
        @user = user
        @workflow = workflow
      end

      class << self
        def deserialize(data)
          workflow = Workflow.deserialize(data&.dig("workflow"))
          chatkit_configuration = ChatKitConfiguration.deserialize(data&.dig("chatkit_configuration"))
          rate_limits = RateLimits.deserialize(data&.dig("rate_limits"))

          new(
            id: data&.dig("id"),
            object: data&.dig("object"),
            status: data&.dig("status"),
            chatkit_configuration:,
            client_secret: data&.dig("client_secret"),
            expires_at: data&.dig("expires_at"),
            max_requests_per_1_minute: data&.dig("max_requests_per_1_minute"),
            rate_limits:,
            user: data&.dig("user"),
            workflow:
          )
        end
      end

      # @return [Hash]
      def serialize
        {
          id:,
          object:,
          status:,
          chatkit_configuration: chatkit_configuration.serialize,
          client_secret:,
          expires_at:,
          max_requests_per_1_minute:,
          rate_limits: rate_limits.serialize,
          user:,
          workflow: workflow.serialize,
        }
      end
    end
  end
end

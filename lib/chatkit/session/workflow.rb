# frozen_string_literal: true

module ChatKit
  class Session
    # Workflow that powers the session.
    #
    # Source: https://platform.openai.com/docs/api-reference/chatkit/sessions/create#chatkit_sessions_create-workflow
    class Workflow
      # @!attribute [r] id
      #  @return [String] The workflow ID.
      attr_accessor :id

      # @!attribute [r] state_variables
      #  @return [Hash, nil] The state variables for the workflow.
      attr_accessor :state_variables

      # @!attribute [r] tracing
      #  @return [Tracing] The tracing information for the workflow.
      attr_accessor :tracing

      # @!attribute [r] version
      #  @return [String, nil] The version of the workflow
      attr_accessor :version

      # @param id [String] The workflow ID.
      # @param state_variables [Hash, nil] - optional - The state variables for the workflow.
      # @param tracing [Hash, nil] - optional - The tracing information for the workflow.
      # @param version [String, nil] - optional - The version of the workflow
      def initialize(id:, state_variables: nil, tracing: nil, version: nil)
        @id = id
        @state_variables = state_variables
        @tracing = setup_tracing(tracing)
        @version = version
      end

      class << self
        def build(id:, state_variables: nil, tracing: nil, version: nil)
          new(id:, state_variables:, tracing:, version:)
        end

        # @param data [Hash, nil]
        #  @return [Workflow]
        def deserialize(data)
          return data if data.is_a?(self)

          tracing = Tracing.deserialize(data&.dig("tracing"))

          new(
            id: data&.dig("id"),
            state_variables: data&.dig("state_variables"),
            version: data&.dig("version"),
            tracing:
          )
        end
      end

      # @return [Hash]
      def serialize
        {
          id:,
          state_variables:,
          tracing: tracing.serialize,
          version:,
        }.compact
      end

    private

      # @param tracing [Hash, nil]
      #  @return [Tracing]
      def setup_tracing(tracing)
        return tracing if tracing.is_a?(Tracing)

        Tracing.build(**tracing.to_h)
      end
    end
  end
end

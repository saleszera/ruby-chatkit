# frozen_string_literal: true

module ChatKit
  class Conversation
    # Represents a conversation response.
    class Response
      # @!attribute [rw] thread
      #  @return [Thread]
      attr_accessor :thread

      def initialize
        @thread = Thread.new
      end

      # Parse incoming streaming event and update the thread accordingly
      # @param event [Hash] The parsed event data
      # @return [void]
      def parse!(event)
        case event["type"]
        when "thread.created", "thread.updated"
          @thread.update!(event)
        when "thread.item.added", "thread.item.done"
          @thread.add_or_update_item!(event)
        when "thread.item.updated"
          @thread.update_item!(event)
        end
      end
    end
  end
end

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

      # Retrieves the final answer content from the thread.
      # @return [Content, nil] The final answer content or nil if not found.
      def answer
        last_item = thread&.items&.last

        return unless last_item

        content = last_item.content

        return unless content

        content.filter { |c| c.type == "output_text" }&.last
      end
    end
  end
end

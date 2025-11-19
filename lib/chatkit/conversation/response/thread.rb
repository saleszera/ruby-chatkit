# frozen_string_literal: true

module ChatKit
  class Conversation
    class Response
      class ThreadItemError < StandardError; end

      # Represents a thread in the conversation response.
      class Thread
        # @!attribute [rw] id
        #  @return [String]
        attr_accessor :id

        # @!attribute [rw] created_at
        #  @return [String]
        attr_accessor :created_at

        # @!attribute [rw] status
        #  @return [String]
        attr_accessor :status

        # @!attribute [rw] title
        #  @return [String, nil]
        attr_accessor :title

        # @!attribute [rw] metadata
        #  @return [Hash, nil]
        attr_accessor :metadata

        # @!attribute [rw] items
        #  @return [Array<ChatKit::Conversation::Response::Thread::Item>, nil]
        attr_accessor :items

        # @param id [String, nil] - optional - The thread ID.
        # @param created_at [String, nil] - optional - The creation timestamp.
        # @param status [String, nil] - optional - The thread status.
        # @param title [String, nil] - optional - The thread title.
        # @param metadata [Hash, nil] - optional - The thread metadata.
        # @param items [Array<ChatKit::Conversation::Response::Thread::Item>, nil] - optional - The thread items.
        def initialize(id: nil, created_at: nil, status: nil, title: nil, metadata: nil)
          @id = id
          @created_at = created_at
          @status = status
          @title = title
          @metadata = metadata
          @items = []
          @current_item = nil
          @mutex = ::Mutex.new
        end

        # Update thread metadata from thread.created or thread.updated events
        # @param event [Hash] The event payload
        # @return [void]
        def update!(event)
          thread_data = event["thread"] || {}

          @id = thread_data["id"] if thread_data.key?("id")
          @created_at = thread_data["created_at"] if thread_data.key?("created_at")
          @status = thread_data["status"] if thread_data.key?("status")
          @title = thread_data["title"] if thread_data.key?("title")
          @metadata = thread_data["metadata"] if thread_data.key?("metadata")
        end

        # Add or update an item from thread.item.added or thread.item.done events
        # @param event [Hash] The event payload
        # @return [Item]
        def add_or_update_item!(event)
          @mutex.synchronize do
            item_data = event["item"] || {}
            item_type = item_data["type"]

            # User message starts a new conversation turn
            if item_type == "user_message"
              @current_item = Item.new
              @current_item.update_from_event!(item_data)
              @items << @current_item
              return @current_item
            end

            # If we don't have a current item, create one
            @current_item ||= Item.new

            # Workflow and assistant messages update the current item
            @current_item.update_from_event!(item_data)

            # Only add to items if not already there
            @items << @current_item unless @items.include?(@current_item)

            @current_item
          end
        end

        # Update an existing item from thread.item.updated events
        # @param event [Hash] The event payload
        # @return [Item, nil]
        def update_item!(event)
          @mutex.synchronize do
            update_data = event["update"] || {}

            # Always update the current item (last item in the conversation)
            item = @current_item || @items.last

            item&.process_update!(update_data)
          end
        end
      end
    end
  end
end

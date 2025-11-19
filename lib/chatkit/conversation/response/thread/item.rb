# frozen_string_literal: true

module ChatKit
  class Conversation
    class Response
      class Thread
        # Represents an item in a thread.
        class Item
          # @!attribute [rw] id
          #  @return [String]
          attr_accessor :id

          # @!attribute [rw] thread_id
          #  @return [String]
          attr_accessor :thread_id

          # @!attribute [rw] created_at
          #  @return [String]
          attr_accessor :created_at

          # @!attribute [rw] attachments
          #  @return [Array<Hash>, nil]
          attr_accessor :attachments

          # @!attribute [rw] inference_options
          #  @return [Hash, nil]
          attr_accessor :inference_options

          # @!attribute [rw] content
          #  @return [Array<Content>]
          attr_accessor :content

          # @!attribute [rw] quoted_text
          #  @return [String, nil]
          attr_accessor :quoted_text

          # @!attribute [rw] delta
          #  @return [Array<String>]
          attr_accessor :delta

          # @!attribute [rw] workflow
          #  @return [Workflow, nil]
          attr_accessor :workflow

          # @param id [String, nil] - optional - The item ID.
          # @param thread_id [String, nil] - optional - The thread ID.
          # @param created_at [String, nil] - optional - The creation timestamp.
          # @param attachments [Array<Hash>, nil] - optional - The item attachments.
          # @param inference_options [Hash, nil] - optional - The inference options.
          # @param content [Array<Content>, nil] - optional - The item content.
          # @param quoted_text [String, nil] - optional - The quoted text.
          # @param workflow [Workflow, nil] - optional - The workflow information.
          def initialize(
            id: nil,
            thread_id: nil,
            created_at: nil,
            attachments: [],
            inference_options: {},
            content: [],
            quoted_text: "",
            workflow: nil
          )
            @id = id
            @thread_id = thread_id
            @created_at = created_at
            @attachments = attachments
            @inference_options = inference_options
            @quoted_text = quoted_text
            @content = parse_content(content)
            @workflow = workflow
            @delta = []
          end

          class << self
            # Create an Item from event data
            # @param data [Hash] The item data from the event
            # @return [Item]
            def from_event(data)
              new(
                id: data["id"],
                thread_id: data["thread_id"],
                created_at: data["created_at"],
                attachments: data["attachments"] || [],
                inference_options: data["inference_options"] || {},
                content: data["content"] || [],
                quoted_text: data["quoted_text"] || "",
                workflow: parse_workflow_data(data)
              )
            end
          end

          # Update item from full event data (thread.item.done)
          # @param data [Hash] The item data
          # @return [void]
          def update_from_event!(data)
            # Set basic fields if not already set
            @id ||= data["id"]
            @thread_id ||= data["thread_id"]
            @created_at ||= data["created_at"]
            @attachments ||= data["attachments"] if data.key?("attachments")
            @inference_options ||= data["inference_options"] if data.key?("inference_options")
            @quoted_text ||= data["quoted_text"] if data.key?("quoted_text")

            # Merge content instead of replacing
            if data.key?("content")
              new_content = parse_content(data["content"])
              new_content.each do |content_part|
                # Only add if not already present (avoid duplicates)
                unless @content.any? { |c| c.type == content_part.type && c.text == content_part.text }
                  @content << content_part
                end
              end
            end

            # Handle workflow: update if exists, create if not
            return unless data.key?("workflow")

            if @workflow
              @workflow.update!(data["workflow"])
            else
              @workflow = parse_workflow_data(data)
            end
          end

          # Process update from thread.item.updated events
          # @param update_data [Hash] The update payload
          # @return [void]
          def process_update!(update_data)
            case update_data["type"]
            when "assistant_message.content_part.added"
              handle_content_part_added!(update_data)
            when "assistant_message.content_part.text_delta"
              handle_text_delta!(update_data)
            when "assistant_message.content_part.done"
              handle_content_part_done!(update_data)
            when /^workflow\./
              handle_workflow_update!(update_data)
            end
          end

        protected

          # Parse workflow data from event
          # @param data [Hash] The event data
          # @return [Workflow, nil]
          def parse_workflow_data(data)
            return nil unless data["workflow"]

            Workflow.from_event(data["workflow"])
          end

        private

          # Parse content array into Content objects
          # @param content_data [Array] The content array
          # @return [Array<Content>]
          def parse_content(content_data)
            return [] unless content_data.is_a?(Array)

            content_data.map do |item|
              if item.is_a?(Content)
                item
              elsif item.is_a?(Hash)
                Content.new(type: item["type"], text: item["text"])
              else
                Content.new
              end
            end
          end

          # Handle assistant_message.content_part.added
          # @param update_data [Hash]
          # @return [void]
          def handle_content_part_added!(update_data)
            content_data = update_data["content"] || {}

            new_content = Content.new(
              type: content_data["type"],
              text: content_data["text"]
            )

            # Only add if this type doesn't already exist
            return if @content.any? { |c| c.type == new_content.type }

            @content << new_content
          end

          # Handle assistant_message.content_part.text_delta
          # @param update_data [Hash]
          # @return [void]
          def handle_text_delta!(update_data)
            delta_text = update_data["delta"]
            return unless delta_text

            @delta << delta_text

            # Find output_text content and update it
            target_content = @content.find { |c| c.type == "output_text" }

            return unless target_content

            target_content.text = @delta.join
          end

          # Handle assistant_message.content_part.done
          # @param update_data [Hash]
          # @return [void]
          def handle_content_part_done!(update_data)
            content_data = update_data["content"] || {}

            # Find output_text content and update it
            target_content = @content.find { |c| c.type == "output_text" }

            if target_content
              target_content.type = content_data["type"] if content_data["type"]
              target_content.text = content_data["text"] if content_data["text"]
            else
              @content << Content.new(
                type: content_data["type"],
                text: content_data["text"]
              )
            end
          end

          # Handle workflow.* updates
          # @param update_data [Hash]
          # @return [void]
          def handle_workflow_update!(update_data)
            @workflow ||= Workflow.new
            @workflow.update!(update_data)
          end
        end
      end
    end
  end
end

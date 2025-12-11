# frozen_string_literal: true

module ChatKit
  class Conversation
    class Response
      class Thread
        class Item
          class Workflow
            # @!attribute [rw] type
            #  @return [String, nil]
            attr_accessor :type

            # @!attribute [rw] tasks
            #  @return [Array, nil]
            attr_accessor :tasks

            # @!attribute [rw] summary
            #  @return [Hash, nil]
            attr_accessor :summary

            # @!attribute [rw] expanded
            #  @return [Boolean, nil]
            attr_accessor :expanded

            # @!attribute [rw] response_items
            #  @return [Array, nil]
            attr_accessor :response_items

            # @param type [String, nil] - optional - The workflow type
            # @param tasks [Array, nil] - optional - The workflow tasks
            # @param summary [Hash, nil] - optional - The workflow summary
            # @param expanded [Boolean, nil] - optional - Whether workflow is expanded
            # @param response_items [Array, nil] - optional - Response items
            def initialize(type: nil, tasks: nil, summary: nil, expanded: nil, response_items: nil)
              @type = type
              @tasks = tasks
              @summary = summary
              @expanded = expanded
              @response_items = response_items
            end

            # Create a Workflow from event data
            # @param data [Hash] The workflow data from the event
            # @return [Workflow]
            def self.from_event(data)
              return nil if data.nil?

              new(
                type: data["type"],
                tasks: data["tasks"],
                summary: data["summary"],
                expanded: data["expanded"],
                response_items: data["response_items"]
              )
            end

            # Update workflow from event data
            # @param data [Hash] The workflow update data
            # @return [void]
            def update!(data)
              @type = data["type"] if data.key?("type")
              @tasks = data["tasks"] if data.key?("tasks")
              @summary = data["summary"] if data.key?("summary")
              @expanded = data["expanded"] if data.key?("expanded")
              @response_items = data["response_items"] if data.key?("response_items")
            end
          end
        end
      end
    end
  end
end

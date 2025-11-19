# frozen_string_literal: true

require "spec_helper"

RSpec.describe ChatKit::Conversation::Response::Thread::Item do
  describe ".new" do
    context "when no arguments are provided" do
      it "initializes with default values" do
        instance = described_class.new
        expect(instance.id).to be_nil
        expect(instance.thread_id).to be_nil
        expect(instance.created_at).to be_nil
        expect(instance.attachments).to eq([])
        expect(instance.inference_options).to eq({})
        expect(instance.content).to eq([])
        expect(instance.quoted_text).to eq("")
        expect(instance.workflow).to be_nil
        expect(instance.delta).to eq([])
      end
    end

    context "when id is provided" do
      it "initializes with the provided id value" do
        instance = described_class.new(id: "cti_123")
        expect(instance.id).to eq("cti_123")
      end
    end

    context "when thread_id is provided" do
      it "initializes with the provided thread_id value" do
        instance = described_class.new(thread_id: "cthr_456")
        expect(instance.thread_id).to eq("cthr_456")
      end
    end

    context "when created_at is provided" do
      it "initializes with the provided created_at value" do
        timestamp = "2025-11-19T10:30:00Z"
        instance = described_class.new(created_at: timestamp)
        expect(instance.created_at).to eq(timestamp)
      end
    end

    context "when attachments is provided" do
      it "initializes with the provided attachments array" do
        attachments = [{ "id" => "att_1", "type" => "file" }]
        instance = described_class.new(attachments:)
        expect(instance.attachments).to eq(attachments)
      end
    end

    context "when inference_options is provided" do
      it "initializes with the provided inference_options hash" do
        options = { "temperature" => 0.7, "max_tokens" => 100 }
        instance = described_class.new(inference_options: options)
        expect(instance.inference_options).to eq(options)
      end
    end

    context "when content is provided" do
      it "initializes with Content objects from hash array" do
        content_data = [
          { "type" => "input_text", "text" => "Hello" },
          { "type" => "output_text", "text" => "Hi there" },
        ]
        instance = described_class.new(content: content_data)

        expect(instance.content.size).to eq(2)
        expect(instance.content.first).to be_a(ChatKit::Conversation::Response::Thread::Item::Content)
        expect(instance.content.first.type).to eq("input_text")
        expect(instance.content.first.text).to eq("Hello")
        expect(instance.content.last.type).to eq("output_text")
        expect(instance.content.last.text).to eq("Hi there")
      end

      it "handles Content objects directly" do
        content_obj = ChatKit::Conversation::Response::Thread::Item::Content.new(
          type: "input_text",
          text: "Hello"
        )
        instance = described_class.new(content: [content_obj])

        expect(instance.content.size).to eq(1)
        expect(instance.content.first).to eq(content_obj)
      end

      it "handles mixed Content objects and hashes" do
        content_obj = ChatKit::Conversation::Response::Thread::Item::Content.new(
          type: "input_text",
          text: "Hello"
        )
        content_data = [
          content_obj,
          { "type" => "output_text", "text" => "Hi" },
        ]
        instance = described_class.new(content: content_data)

        expect(instance.content.size).to eq(2)
        expect(instance.content.first).to eq(content_obj)
        expect(instance.content.last.type).to eq("output_text")
      end

      it "handles empty content array" do
        instance = described_class.new(content: [])
        expect(instance.content).to eq([])
      end

      it "handles invalid content data" do
        instance = described_class.new(content: ["invalid", 123])
        expect(instance.content.size).to eq(2)
        expect(instance.content.first).to be_a(ChatKit::Conversation::Response::Thread::Item::Content)
        expect(instance.content.first.type).to be_nil
        expect(instance.content.first.text).to be_nil
      end
    end

    context "when quoted_text is provided" do
      it "initializes with the provided quoted_text value" do
        instance = described_class.new(quoted_text: "Previous message")
        expect(instance.quoted_text).to eq("Previous message")
      end
    end

    context "when workflow is provided" do
      it "initializes with the provided workflow object" do
        workflow = ChatKit::Conversation::Response::Thread::Item::Workflow.new(type: "reasoning")
        instance = described_class.new(workflow:)
        expect(instance.workflow).to eq(workflow)
      end
    end

    context "when all parameters are provided" do
      it "initializes with all values" do
        workflow = ChatKit::Conversation::Response::Thread::Item::Workflow.new(type: "reasoning")
        instance = described_class.new(
          id: "cti_123",
          thread_id: "cthr_456",
          created_at: "2025-11-19T10:30:00Z",
          attachments: [{ "id" => "att_1" }],
          inference_options: { "temperature" => 0.7 },
          content: [{ "type" => "input_text", "text" => "Hello" }],
          quoted_text: "Previous",
          workflow:
        )

        expect(instance.id).to eq("cti_123")
        expect(instance.thread_id).to eq("cthr_456")
        expect(instance.created_at).to eq("2025-11-19T10:30:00Z")
        expect(instance.attachments).to eq([{ "id" => "att_1" }])
        expect(instance.inference_options).to eq({ "temperature" => 0.7 })
        expect(instance.content.size).to eq(1)
        expect(instance.quoted_text).to eq("Previous")
        expect(instance.workflow).to eq(workflow)
      end
    end
  end

  describe ".from_event" do
    it "creates an Item from event data" do
      event_data = {
        "id" => "cti_123",
        "thread_id" => "cthr_456",
        "created_at" => "2025-11-19T10:30:00Z",
        "attachments" => [{ "id" => "att_1" }],
        "inference_options" => { "temperature" => 0.7 },
        "content" => [{ "type" => "input_text", "text" => "Hello" }],
        "quoted_text" => "Previous message",
      }

      instance = described_class.from_event(event_data)

      expect(instance.id).to eq("cti_123")
      expect(instance.thread_id).to eq("cthr_456")
      expect(instance.created_at).to eq("2025-11-19T10:30:00Z")
      expect(instance.attachments).to eq([{ "id" => "att_1" }])
      expect(instance.inference_options).to eq({ "temperature" => 0.7 })
      expect(instance.content.size).to eq(1)
      expect(instance.content.first.type).to eq("input_text")
      expect(instance.content.first.text).to eq("Hello")
      expect(instance.quoted_text).to eq("Previous message")
    end

    it "creates an Item with workflow data" do
      event_data = {
        "id" => "cti_workflow_1",
        "thread_id" => "cthr_123",
        "created_at" => "2025-11-19T10:30:00Z",
        "workflow" => {
          "type" => "reasoning",
          "tasks" => [{ "id" => "task1" }],
          "expanded" => false,
        },
      }

      instance = described_class.from_event(event_data)

      expect(instance.id).to eq("cti_workflow_1")
      expect(instance.workflow).not_to be_nil
      expect(instance.workflow.type).to eq("reasoning")
      expect(instance.workflow.tasks).to eq([{ "id" => "task1" }])
      expect(instance.workflow.expanded).to be(false)
    end

    it "handles missing optional fields with defaults" do
      event_data = {
        "id" => "cti_123",
        "thread_id" => "cthr_456",
        "created_at" => "2025-11-19T10:30:00Z",
      }

      instance = described_class.from_event(event_data)

      expect(instance.attachments).to eq([])
      expect(instance.inference_options).to eq({})
      expect(instance.content).to eq([])
      expect(instance.quoted_text).to eq("")
      expect(instance.workflow).to be_nil
    end

    it "handles nil values for optional fields" do
      event_data = {
        "id" => "cti_123",
        "thread_id" => "cthr_456",
        "created_at" => "2025-11-19T10:30:00Z",
        "attachments" => nil,
        "inference_options" => nil,
        "content" => nil,
        "quoted_text" => nil,
      }

      instance = described_class.from_event(event_data)

      expect(instance.attachments).to eq([])
      expect(instance.inference_options).to eq({})
      expect(instance.content).to eq([])
      expect(instance.quoted_text).to eq("")
    end
  end

  describe "#update_from_event!" do
    let(:instance) { described_class.new(id: "cti_123") }

    it "sets basic fields if not already set" do
      instance.update_from_event!({
        "id" => "cti_456",
        "thread_id" => "cthr_789",
        "created_at" => "2025-11-19T10:30:00Z",
      })

      expect(instance.id).to eq("cti_123") # Already set, not changed
      expect(instance.thread_id).to eq("cthr_789")
      expect(instance.created_at).to eq("2025-11-19T10:30:00Z")
    end

    it "sets attachments if present and not already set" do
      instance.attachments = nil
      attachments = [{ "id" => "att_1" }]
      instance.update_from_event!({ "attachments" => attachments })
      expect(instance.attachments).to eq(attachments)
    end

    it "sets inference_options if present and not already set" do
      instance.inference_options = nil
      options = { "temperature" => 0.7 }
      instance.update_from_event!({ "inference_options" => options })
      expect(instance.inference_options).to eq(options)
    end

    it "sets quoted_text if present and not already set" do
      instance.quoted_text = nil
      instance.update_from_event!({ "quoted_text" => "Quote" })
      expect(instance.quoted_text).to eq("Quote")
    end

    it "merges content without duplicates" do
      instance.content << ChatKit::Conversation::Response::Thread::Item::Content.new(
        type: "input_text",
        text: "Hello"
      )

      instance.update_from_event!({
        "content" => [
          { "type" => "input_text", "text" => "Hello" }, # Duplicate
          { "type" => "output_text", "text" => "Hi" }, # New
        ],
      })

      expect(instance.content.size).to eq(2)
      expect(instance.content.first.type).to eq("input_text")
      expect(instance.content.last.type).to eq("output_text")
    end

    it "adds new content when type and text differ" do
      instance.content << ChatKit::Conversation::Response::Thread::Item::Content.new(
        type: "input_text",
        text: "Hello"
      )

      instance.update_from_event!({
        "content" => [
          { "type" => "input_text", "text" => "Different" }, # Different text
        ],
      })

      expect(instance.content.size).to eq(2)
    end

    it "creates workflow from event data if present" do
      instance.update_from_event!({
        "workflow" => {
          "type" => "reasoning",
          "tasks" => [{ "id" => "task1" }],
        },
      })

      expect(instance.workflow).not_to be_nil
      expect(instance.workflow.type).to eq("reasoning")
      expect(instance.workflow.tasks).to eq([{ "id" => "task1" }])
    end

    it "updates existing workflow when called multiple times" do
      # First event: thread.item.added with initial workflow
      instance.update_from_event!({
        "id" => "cti_workflow_1",
        "workflow" => {
          "type" => "reasoning",
          "tasks" => [],
          "expanded" => false,
        },
      })

      expect(instance.workflow).not_to be_nil
      expect(instance.workflow.type).to eq("reasoning")
      expect(instance.workflow.tasks).to eq([])
      expect(instance.workflow.summary).to be_nil

      # Second event: thread.item.done with updated workflow (includes summary)
      instance.update_from_event!({
        "id" => "cti_workflow_1",
        "workflow" => {
          "type" => "reasoning",
          "tasks" => [],
          "summary" => { "duration" => 8 },
          "expanded" => false,
        },
      })

      expect(instance.workflow).not_to be_nil
      expect(instance.workflow.type).to eq("reasoning")
      expect(instance.workflow.tasks).to eq([])
      expect(instance.workflow.summary).to eq({ "duration" => 8 })
      expect(instance.workflow.expanded).to eq(false)
    end

    it "does not update workflow if not present in data" do
      original_workflow = ChatKit::Conversation::Response::Thread::Item::Workflow.new(type: "original")
      instance.workflow = original_workflow

      instance.update_from_event!({ "id" => "cti_123" })

      expect(instance.workflow).to eq(original_workflow)
    end
  end

  describe "#process_update!" do
    let(:instance) { described_class.new(id: "cti_123") }

    context "with assistant_message.content_part.added event" do
      it "adds new content part" do
        update_data = {
          "type" => "assistant_message.content_part.added",
          "content" => {
            "type" => "output_text",
            "text" => "Hello",
          },
        }

        instance.process_update!(update_data)

        expect(instance.content.size).to eq(1)
        expect(instance.content.first.type).to eq("output_text")
        expect(instance.content.first.text).to eq("Hello")
      end

      it "does not add duplicate content type" do
        instance.content << ChatKit::Conversation::Response::Thread::Item::Content.new(
          type: "output_text",
          text: "Existing"
        )

        update_data = {
          "type" => "assistant_message.content_part.added",
          "content" => {
            "type" => "output_text",
            "text" => "New",
          },
        }

        instance.process_update!(update_data)

        expect(instance.content.size).to eq(1)
        expect(instance.content.first.text).to eq("Existing")
      end

      it "handles missing content data" do
        update_data = {
          "type" => "assistant_message.content_part.added",
        }

        expect { instance.process_update!(update_data) }.not_to raise_error
      end
    end

    context "with assistant_message.content_part.text_delta event" do
      it "appends delta to existing output_text content" do
        instance.content << ChatKit::Conversation::Response::Thread::Item::Content.new(
          type: "output_text",
          text: ""
        )

        instance.process_update!({
          "type" => "assistant_message.content_part.text_delta",
          "delta" => "Hello",
        })
        instance.process_update!({
          "type" => "assistant_message.content_part.text_delta",
          "delta" => " world",
        })

        expect(instance.content.first.text).to eq("Hello world")
        expect(instance.delta).to eq(["Hello", " world"])
      end

      it "builds text from multiple deltas" do
        instance.content << ChatKit::Conversation::Response::Thread::Item::Content.new(
          type: "output_text",
          text: ""
        )

        instance.process_update!({
          "type" => "assistant_message.content_part.text_delta",
          "delta" => "Hello",
        })
        instance.process_update!({
          "type" => "assistant_message.content_part.text_delta",
          "delta" => " ",
        })
        instance.process_update!({
          "type" => "assistant_message.content_part.text_delta",
          "delta" => "world",
        })

        expect(instance.content.first.text).to eq("Hello world")
        expect(instance.delta).to eq(["Hello", " ", "world"])
      end

      it "does nothing if no output_text content exists" do
        instance.process_update!({
          "type" => "assistant_message.content_part.text_delta",
          "delta" => "Hello",
        })

        expect(instance.delta).to eq(["Hello"])
        expect(instance.content).to be_empty
      end

      it "handles missing delta data" do
        instance.content << ChatKit::Conversation::Response::Thread::Item::Content.new(
          type: "output_text",
          text: "Hello"
        )

        expect do
          instance.process_update!({
            "type" => "assistant_message.content_part.text_delta",
          })
        end.not_to raise_error
      end
    end

    context "with assistant_message.content_part.done event" do
      it "updates existing output_text content" do
        instance.content << ChatKit::Conversation::Response::Thread::Item::Content.new(
          type: "output_text",
          text: "Partial"
        )

        instance.process_update!({
          "type" => "assistant_message.content_part.done",
          "content" => {
            "type" => "text",
            "text" => "Complete message",
          },
        })

        expect(instance.content.size).to eq(1)
        expect(instance.content.first.type).to eq("text")
        expect(instance.content.first.text).to eq("Complete message")
      end

      it "creates new content if output_text does not exist" do
        instance.process_update!({
          "type" => "assistant_message.content_part.done",
          "content" => {
            "type" => "text",
            "text" => "New message",
          },
        })

        expect(instance.content.size).to eq(1)
        expect(instance.content.first.type).to eq("text")
        expect(instance.content.first.text).to eq("New message")
      end

      it "handles partial content data" do
        instance.content << ChatKit::Conversation::Response::Thread::Item::Content.new(
          type: "output_text",
          text: "Original"
        )

        instance.process_update!({
          "type" => "assistant_message.content_part.done",
          "content" => {
            "text" => "Updated",
          },
        })

        expect(instance.content.first.type).to eq("output_text")
        expect(instance.content.first.text).to eq("Updated")
      end

      it "handles missing content data" do
        expect do
          instance.process_update!({
            "type" => "assistant_message.content_part.done",
          })
        end.not_to raise_error
      end
    end

    context "with workflow.* events" do
      it "creates workflow if it does not exist" do
        instance.process_update!({
          "type" => "workflow.task.added",
          "tasks" => [{ "id" => "task1" }],
        })

        expect(instance.workflow).not_to be_nil
        expect(instance.workflow.tasks).to eq([{ "id" => "task1" }])
      end

      it "updates existing workflow" do
        instance.workflow = ChatKit::Conversation::Response::Thread::Item::Workflow.new(
          type: "reasoning"
        )

        instance.process_update!({
          "type" => "workflow.updated",
          "summary" => { "duration" => 5 },
        })

        expect(instance.workflow.type).to eq("workflow.updated")
        expect(instance.workflow.summary).to eq({ "duration" => 5 })
      end

      it "handles various workflow event types" do
        %w[
          workflow.created
          workflow.updated
          workflow.task.added
          workflow.completed
        ].each do |event_type|
          instance.workflow = nil
          instance.process_update!({
            "type" => event_type,
            "tasks" => [],
          })
          expect(instance.workflow).not_to be_nil
        end
      end
    end

    context "with unknown event type" do
      it "does nothing" do
        original_content_size = instance.content.size
        original_workflow = instance.workflow

        instance.process_update!({
          "type" => "unknown.event.type",
          "data" => "something",
        })

        expect(instance.content.size).to eq(original_content_size)
        expect(instance.workflow).to eq(original_workflow)
      end
    end
  end

  describe "attribute accessors" do
    let(:instance) { described_class.new }

    describe "#id" do
      it "allows reading and writing" do
        expect(instance.id).to be_nil
        instance.id = "cti_new"
        expect(instance.id).to eq("cti_new")
      end
    end

    describe "#thread_id" do
      it "allows reading and writing" do
        expect(instance.thread_id).to be_nil
        instance.thread_id = "cthr_new"
        expect(instance.thread_id).to eq("cthr_new")
      end
    end

    describe "#created_at" do
      it "allows reading and writing" do
        expect(instance.created_at).to be_nil
        timestamp = "2025-11-19T10:30:00Z"
        instance.created_at = timestamp
        expect(instance.created_at).to eq(timestamp)
      end
    end

    describe "#attachments" do
      it "allows reading and writing" do
        expect(instance.attachments).to eq([])
        attachments = [{ "id" => "att_1" }]
        instance.attachments = attachments
        expect(instance.attachments).to eq(attachments)
      end
    end

    describe "#inference_options" do
      it "allows reading and writing" do
        expect(instance.inference_options).to eq({})
        options = { "temperature" => 0.7 }
        instance.inference_options = options
        expect(instance.inference_options).to eq(options)
      end
    end

    describe "#content" do
      it "allows reading and writing" do
        expect(instance.content).to eq([])
        content = [ChatKit::Conversation::Response::Thread::Item::Content.new(type: "text")]
        instance.content = content
        expect(instance.content).to eq(content)
      end
    end

    describe "#quoted_text" do
      it "allows reading and writing" do
        expect(instance.quoted_text).to eq("")
        instance.quoted_text = "New quote"
        expect(instance.quoted_text).to eq("New quote")
      end
    end

    describe "#delta" do
      it "allows reading and writing" do
        expect(instance.delta).to eq([])
        instance.delta = ["Hello", " world"]
        expect(instance.delta).to eq(["Hello", " world"])
      end
    end

    describe "#workflow" do
      it "allows reading and writing" do
        expect(instance.workflow).to be_nil
        workflow = ChatKit::Conversation::Response::Thread::Item::Workflow.new(type: "reasoning")
        instance.workflow = workflow
        expect(instance.workflow).to eq(workflow)
      end
    end
  end
end

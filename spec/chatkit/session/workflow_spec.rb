# frozen_string_literal: true

RSpec.describe ChatKit::Session::Workflow do
  describe ".new" do
    context "when only required arguments are provided" do
      it "initializes with id" do
        instance = described_class.new(id: "wf_123")
        expect(instance.id).to eq("wf_123")
      end

      it "sets state_variables to nil by default" do
        instance = described_class.new(id: "wf_123")
        expect(instance.state_variables).to be_nil
      end

      it "sets tracing to Tracing instance by default" do
        instance = described_class.new(id: "wf_123")
        expect(instance.tracing).to be_a(ChatKit::Session::Workflow::Tracing)
      end

      it "sets version to nil by default" do
        instance = described_class.new(id: "wf_123")
        expect(instance.version).to be_nil
      end
    end

    context "when all arguments are provided" do
      it "initializes with all values" do
        tracing_hash = { enabled: true }
        instance = described_class.new(
          id: "wf_456",
          state_variables: { "key" => "value" },
          tracing: tracing_hash,
          version: "2.0.0"
        )

        expect(instance.id).to eq("wf_456")
        expect(instance.state_variables).to eq({ "key" => "value" })
        expect(instance.tracing).to be_a(ChatKit::Session::Workflow::Tracing)
        expect(instance.version).to eq("2.0.0")
      end

      it "accepts Tracing instance directly" do
        tracing_instance = ChatKit::Session::Workflow::Tracing.new(enabled: true)
        instance = described_class.new(id: "wf_789", tracing: tracing_instance)
        expect(instance.tracing).to eq(tracing_instance)
      end

      it "accepts nil state_variables explicitly" do
        instance = described_class.new(id: "wf_123", state_variables: nil)
        expect(instance.state_variables).to be_nil
      end

      it "accepts empty hash for state_variables" do
        instance = described_class.new(id: "wf_123", state_variables: {})
        expect(instance.state_variables).to eq({})
      end

      it "accepts complex nested state_variables" do
        state = {
          "config" => { "timeout" => 30 },
          "flags" => ["debug"],
        }
        instance = described_class.new(id: "wf_123", state_variables: state)
        expect(instance.state_variables).to eq(state)
      end
    end
  end

  describe ".build" do
    context "when only id is provided" do
      it "creates instance with id" do
        instance = described_class.build(id: "wf_build_123")
        expect(instance).to be_a(described_class)
        expect(instance.id).to eq("wf_build_123")
      end

      it "sets state_variables to nil" do
        instance = described_class.build(id: "wf_build_123")
        expect(instance.state_variables).to be_nil
      end

      it "sets version to nil" do
        instance = described_class.build(id: "wf_build_123")
        expect(instance.version).to be_nil
      end

      it "creates Tracing instance" do
        instance = described_class.build(id: "wf_build_123")
        expect(instance.tracing).to be_a(ChatKit::Session::Workflow::Tracing)
      end
    end

    context "when all parameters are provided" do
      it "creates instance with all values" do
        instance = described_class.build(
          id: "wf_build_456",
          state_variables: { "var" => "val" },
          tracing: { enabled: false },
          version: "3.0.0"
        )

        expect(instance.id).to eq("wf_build_456")
        expect(instance.state_variables).to eq({ "var" => "val" })
        expect(instance.tracing.enabled).to eq(false)
        expect(instance.version).to eq("3.0.0")
      end
    end

    it "returns an instance of Workflow" do
      instance = described_class.build(id: "wf_test")
      expect(instance).to be_a(described_class)
    end
  end

  describe ".deserialize" do
    context "when data is nil" do
      it "initializes with nil id" do
        instance = described_class.deserialize(nil)
        expect(instance.id).to be_nil
      end

      it "initializes with nil state_variables" do
        instance = described_class.deserialize(nil)
        expect(instance.state_variables).to be_nil
      end

      it "initializes with nil version" do
        instance = described_class.deserialize(nil)
        expect(instance.version).to be_nil
      end

      it "creates Tracing instance from nil" do
        instance = described_class.deserialize(nil)
        expect(instance.tracing).to be_a(ChatKit::Session::Workflow::Tracing)
      end

      it "returns an instance of Workflow" do
        instance = described_class.deserialize(nil)
        expect(instance).to be_a(described_class)
      end
    end

    context "when data is an empty hash" do
      it "initializes with nil values" do
        instance = described_class.deserialize({})
        expect(instance.id).to be_nil
        expect(instance.state_variables).to be_nil
        expect(instance.version).to be_nil
      end
    end

    context "when data contains all keys" do
      it "deserializes complete workflow data" do
        data = {
          "id" => "wf_deserialize_123",
          "state_variables" => { "key" => "value" },
          "tracing" => { "enabled" => true },
          "version" => "4.0.0",
        }
        instance = described_class.deserialize(data)

        expect(instance.id).to eq("wf_deserialize_123")
        expect(instance.state_variables).to eq({ "key" => "value" })
        expect(instance.tracing.enabled).to eq(true)
        expect(instance.version).to eq("4.0.0")
      end

      it "deserializes with nil state_variables" do
        data = {
          "id" => "wf_123",
          "state_variables" => nil,
          "version" => "1.0.0",
        }
        instance = described_class.deserialize(data)
        expect(instance.state_variables).to be_nil
      end

      it "deserializes with empty state_variables" do
        data = {
          "id" => "wf_123",
          "state_variables" => {},
        }
        instance = described_class.deserialize(data)
        expect(instance.state_variables).to eq({})
      end

      it "deserializes with complex state_variables" do
        data = {
          "id" => "wf_123",
          "state_variables" => {
            "nested" => { "data" => "value" },
            "array" => [1, 2, 3],
          },
        }
        instance = described_class.deserialize(data)
        expect(instance.state_variables).to eq(data["state_variables"])
      end

      it "deserializes tracing as Tracing object" do
        data = {
          "id" => "wf_123",
          "tracing" => { "enabled" => false },
        }
        instance = described_class.deserialize(data)
        expect(instance.tracing).to be_a(ChatKit::Session::Workflow::Tracing)
        expect(instance.tracing.enabled).to eq(false)
      end
    end

    context "when data contains extra keys" do
      it "extracts only known keys using dig" do
        data = {
          "id" => "wf_extra",
          "state_variables" => { "var" => "val" },
          "version" => "5.0.0",
          "extra_key" => "ignored",
          "another_extra" => "also_ignored",
        }
        instance = described_class.deserialize(data)

        expect(instance.id).to eq("wf_extra")
        expect(instance.state_variables).to eq({ "var" => "val" })
        expect(instance.version).to eq("5.0.0")
      end
    end

    it "returns an instance of Workflow" do
      instance = described_class.deserialize({ "id" => "wf_test" })
      expect(instance).to be_a(described_class)
    end
  end

  describe "#serialize" do
    context "when all attributes have values" do
      it "serializes to complete hash" do
        tracing = ChatKit::Session::Workflow::Tracing.new(enabled: true)
        instance = described_class.new(
          id: "wf_serialize_123",
          state_variables: { "key" => "value" },
          tracing:,
          version: "6.0.0"
        )
        result = instance.serialize

        expect(result[:id]).to eq("wf_serialize_123")
        expect(result[:state_variables]).to eq({ "key" => "value" })
        expect(result[:tracing]).to be_a(Hash)
        expect(result[:version]).to eq("6.0.0")
      end

      it "calls serialize on tracing object" do
        tracing = ChatKit::Session::Workflow::Tracing.new(enabled: false)
        instance = described_class.new(id: "wf_123", tracing:)
        result = instance.serialize

        expect(result[:tracing]).to eq(tracing.serialize)
      end
    end

    context "when optional attributes are nil" do
      it "compacts nil values from serialized hash" do
        instance = described_class.new(
          id: "wf_compact",
          state_variables: nil,
          version: nil
        )
        result = instance.serialize

        expect(result).to have_key(:id)
        expect(result).to have_key(:tracing)
        expect(result).not_to have_key(:state_variables)
        expect(result).not_to have_key(:version)
      end
    end

    context "when state_variables is empty hash" do
      it "includes empty hash in serialization" do
        instance = described_class.new(id: "wf_123", state_variables: {})
        result = instance.serialize
        expect(result[:state_variables]).to eq({})
      end
    end

    context "when state_variables has complex structure" do
      it "serializes complex nested structure" do
        state = {
          "config" => { "timeout" => 30, "retries" => 3 },
          "flags" => %w[debug verbose],
        }
        instance = described_class.new(id: "wf_123", state_variables: state)
        result = instance.serialize
        expect(result[:state_variables]).to eq(state)
      end
    end

    it "returns a hash" do
      instance = described_class.new(id: "wf_test")
      result = instance.serialize
      expect(result).to be_a(Hash)
    end
  end

  describe "attribute accessors" do
    let(:instance) { described_class.new(id: "wf_accessor_test") }

    describe "#id" do
      it "allows reading the id value" do
        expect(instance.id).to eq("wf_accessor_test")
      end

      it "allows writing new id value" do
        instance.id = "wf_new_id"
        expect(instance.id).to eq("wf_new_id")
      end

      it "allows setting to nil" do
        instance.id = nil
        expect(instance.id).to be_nil
      end
    end

    describe "#state_variables" do
      it "allows reading the state_variables value" do
        expect(instance.state_variables).to be_nil
      end

      it "allows writing hash value" do
        instance.state_variables = { "new_key" => "new_value" }
        expect(instance.state_variables).to eq({ "new_key" => "new_value" })
      end

      it "allows writing nil value" do
        instance.state_variables = { "key" => "value" }
        instance.state_variables = nil
        expect(instance.state_variables).to be_nil
      end

      it "allows writing empty hash" do
        instance.state_variables = {}
        expect(instance.state_variables).to eq({})
      end
    end

    describe "#tracing" do
      it "allows reading the tracing value" do
        expect(instance.tracing).to be_a(ChatKit::Session::Workflow::Tracing)
      end

      it "allows writing new Tracing instance" do
        new_tracing = ChatKit::Session::Workflow::Tracing.new(enabled: false)
        instance.tracing = new_tracing
        expect(instance.tracing).to eq(new_tracing)
      end
    end

    describe "#version" do
      it "allows reading the version value" do
        expect(instance.version).to be_nil
      end

      it "allows writing string value" do
        instance.version = "7.0.0"
        expect(instance.version).to eq("7.0.0")
      end

      it "allows writing nil value" do
        instance.version = "1.0.0"
        instance.version = nil
        expect(instance.version).to be_nil
      end
    end
  end

  describe "integration with FactoryBot" do
    context "using default factory" do
      it "creates valid instance" do
        instance = build(:workflow)
        expect(instance).to be_a(described_class)
        expect(instance.id).to eq("wf_abc123")
        expect(instance.state_variables).to eq({ "variable1" => "value1", "variable2" => "value2" })
        expect(instance.tracing).to be_a(ChatKit::Session::Workflow::Tracing)
        expect(instance.version).to eq("1.0.0")
      end
    end

    context "using :minimal trait" do
      it "creates instance with minimal attributes" do
        instance = build(:workflow, :minimal)
        expect(instance.id).to eq("wf_abc123")
        expect(instance.state_variables).to be_nil
        expect(instance.version).to be_nil
      end
    end

    context "using :with_nil_state trait" do
      it "creates instance with nil state_variables" do
        instance = build(:workflow, :with_nil_state)
        expect(instance.state_variables).to be_nil
      end
    end

    context "using :with_empty_state trait" do
      it "creates instance with empty state_variables" do
        instance = build(:workflow, :with_empty_state)
        expect(instance.state_variables).to eq({})
      end
    end

    context "using :with_nil_version trait" do
      it "creates instance with nil version" do
        instance = build(:workflow, :with_nil_version)
        expect(instance.version).to be_nil
      end
    end

    context "using :with_complex_state trait" do
      it "creates instance with complex state_variables" do
        instance = build(:workflow, :with_complex_state)
        expect(instance.state_variables).to include("config", "user_input", "flags")
        expect(instance.state_variables["config"]).to eq({ "timeout" => 30, "retries" => 3 })
        expect(instance.state_variables["flags"]).to eq(%w[debug verbose])
      end
    end

    context "overriding attributes" do
      it "allows custom id" do
        instance = build(:workflow, id: "wf_custom")
        expect(instance.id).to eq("wf_custom")
      end

      it "allows custom state_variables" do
        instance = build(:workflow, state_variables: { "custom" => "state" })
        expect(instance.state_variables).to eq({ "custom" => "state" })
      end

      it "allows custom version" do
        instance = build(:workflow, version: "10.0.0")
        expect(instance.version).to eq("10.0.0")
      end
    end
  end

  describe "round-trip serialization" do
    it "maintains data integrity with all attributes" do
      original = described_class.new(
        id: "wf_roundtrip",
        state_variables: { "key" => "value" },
        version: "8.0.0"
      )
      serialized = original.serialize
      deserialized = described_class.deserialize(JSON.parse(serialized.to_json))

      expect(deserialized.id).to eq(original.id)
      expect(deserialized.state_variables).to eq(original.state_variables)
      expect(deserialized.version).to eq(original.version)
    end

    it "maintains data integrity with minimal attributes" do
      original = described_class.new(id: "wf_minimal")
      serialized = original.serialize
      deserialized = described_class.deserialize(JSON.parse(serialized.to_json))

      expect(deserialized.id).to eq(original.id)
      expect(deserialized.state_variables).to eq(original.state_variables)
      expect(deserialized.version).to eq(original.version)
    end

    it "maintains data integrity with complex state_variables" do
      original = described_class.new(
        id: "wf_complex",
        state_variables: {
          "nested" => { "deep" => { "value" => 123 } },
          "array" => [1, 2, 3],
        }
      )
      serialized = original.serialize
      deserialized = described_class.deserialize(JSON.parse(serialized.to_json))

      expect(deserialized.state_variables).to eq(original.state_variables)
    end

    it "maintains tracing data integrity" do
      original = described_class.new(
        id: "wf_tracing",
        tracing: { enabled: true }
      )
      serialized = original.serialize
      deserialized = described_class.deserialize(JSON.parse(serialized.to_json))

      expect(deserialized.tracing.enabled).to eq(original.tracing.enabled)
    end
  end

  describe "edge cases" do
    context "when modifying attributes after initialization" do
      it "allows changing id" do
        instance = described_class.new(id: "wf_original")
        expect(instance.id).to eq("wf_original")

        instance.id = "wf_modified"
        expect(instance.id).to eq("wf_modified")
      end

      it "allows changing state_variables" do
        instance = described_class.new(id: "wf_123", state_variables: { "old" => "value" })
        instance.state_variables = { "new" => "value" }
        expect(instance.state_variables).to eq({ "new" => "value" })
      end

      it "allows changing version" do
        instance = described_class.new(id: "wf_123", version: "1.0.0")
        instance.version = "2.0.0"
        expect(instance.version).to eq("2.0.0")
      end

      it "allows changing tracing" do
        instance = described_class.new(id: "wf_123")
        new_tracing = ChatKit::Session::Workflow::Tracing.new(enabled: false)
        instance.tracing = new_tracing
        expect(instance.tracing.enabled).to eq(false)
      end
    end

    context "when serializing multiple times" do
      it "produces consistent results" do
        instance = described_class.new(
          id: "wf_consistent",
          state_variables: { "key" => "value" },
          version: "9.0.0"
        )
        first_serialization = instance.serialize
        second_serialization = instance.serialize

        expect(first_serialization).to eq(second_serialization)
      end
    end

    context "when modifying after serialization" do
      it "subsequent serializations reflect modifications" do
        instance = described_class.new(id: "wf_123", version: "1.0.0")
        first_result = instance.serialize
        expect(first_result[:version]).to eq("1.0.0")

        instance.version = "2.0.0"
        second_result = instance.serialize
        expect(second_result[:version]).to eq("2.0.0")
      end

      it "handles transition to nil" do
        instance = described_class.new(id: "wf_123", version: "1.0.0")
        first_result = instance.serialize
        expect(first_result).to have_key(:version)

        instance.version = nil
        second_result = instance.serialize
        expect(second_result).not_to have_key(:version)
      end
    end

    context "when deserializing with unexpected data types" do
      it "handles string values for state_variables" do
        data = {
          "id" => "wf_123",
          "state_variables" => "not_a_hash",
        }
        instance = described_class.deserialize(data)
        expect(instance.state_variables).to eq("not_a_hash")
      end

      it "handles numeric id" do
        data = { "id" => 123 }
        instance = described_class.deserialize(data)
        expect(instance.id).to eq(123)
      end
    end

    context "when working with tracing parameter" do
      it "converts hash to Tracing instance on initialization" do
        instance = described_class.new(id: "wf_123", tracing: { enabled: true })
        expect(instance.tracing).to be_a(ChatKit::Session::Workflow::Tracing)
        expect(instance.tracing.enabled).to eq(true)
      end

      it "converts empty hash to Tracing instance" do
        instance = described_class.new(id: "wf_123", tracing: {})
        expect(instance.tracing).to be_a(ChatKit::Session::Workflow::Tracing)
      end

      it "preserves Tracing instance when passed directly" do
        tracing = ChatKit::Session::Workflow::Tracing.new(enabled: false)
        instance = described_class.new(id: "wf_123", tracing:)
        expect(instance.tracing).to equal(tracing)
      end

      it "handles nil tracing parameter" do
        instance = described_class.new(id: "wf_123", tracing: nil)
        expect(instance.tracing).to be_a(ChatKit::Session::Workflow::Tracing)
      end
    end

    context "when working with state_variables structure" do
      it "preserves array values" do
        state = { "list" => [1, 2, 3, 4, 5] }
        instance = described_class.new(id: "wf_123", state_variables: state)
        expect(instance.state_variables["list"]).to eq([1, 2, 3, 4, 5])
      end

      it "preserves deeply nested structures" do
        state = {
          "level1" => {
            "level2" => {
              "level3" => {
                "value" => "deep",
              },
            },
          },
        }
        instance = described_class.new(id: "wf_123", state_variables: state)
        expect(instance.state_variables.dig("level1", "level2", "level3", "value")).to eq("deep")
      end

      it "preserves mixed types" do
        state = {
          "string" => "text",
          "number" => 42,
          "boolean" => true,
          "null" => nil,
          "array" => [1, 2, 3],
          "object" => { "nested" => "value" },
        }
        instance = described_class.new(id: "wf_123", state_variables: state)
        expect(instance.state_variables).to eq(state)
      end
    end
  end

  describe "private methods" do
    describe "#setup_tracing" do
      it "returns Tracing instance when given Tracing object" do
        tracing = ChatKit::Session::Workflow::Tracing.new(enabled: true)
        instance = described_class.new(id: "wf_123", tracing:)
        expect(instance.tracing).to equal(tracing)
      end

      it "converts hash to Tracing instance" do
        instance = described_class.new(id: "wf_123", tracing: { enabled: false })
        expect(instance.tracing).to be_a(ChatKit::Session::Workflow::Tracing)
        expect(instance.tracing.enabled).to eq(false)
      end

      it "handles nil by creating Tracing with no arguments" do
        instance = described_class.new(id: "wf_123", tracing: nil)
        expect(instance.tracing).to be_a(ChatKit::Session::Workflow::Tracing)
      end
    end
  end

  describe "API documentation compliance" do
    context "according to OpenAI API reference" do
      it "requires id parameter" do
        expect { described_class.new }.to raise_error(ArgumentError)
      end

      it "accepts optional state_variables" do
        instance = described_class.new(id: "wf_123")
        expect(instance.state_variables).to be_nil
      end

      it "accepts optional tracing" do
        instance = described_class.new(id: "wf_123")
        expect(instance.tracing).to be_a(ChatKit::Session::Workflow::Tracing)
      end

      it "accepts optional version" do
        instance = described_class.new(id: "wf_123")
        expect(instance.version).to be_nil
      end
    end
  end

  describe "common use cases" do
    context "workflow creation scenarios" do
      it "creates workflow with just id" do
        workflow = described_class.new(id: "wf_simple")
        expect(workflow.id).to eq("wf_simple")
      end

      it "creates workflow with id and version" do
        workflow = described_class.new(id: "wf_versioned", version: "1.2.3")
        expect(workflow.id).to eq("wf_versioned")
        expect(workflow.version).to eq("1.2.3")
      end

      it "creates workflow with state" do
        workflow = described_class.new(
          id: "wf_stateful",
          state_variables: { "user_id" => "123", "session_id" => "abc" }
        )
        expect(workflow.state_variables).to include("user_id", "session_id")
      end

      it "creates workflow with tracing enabled" do
        workflow = described_class.new(
          id: "wf_traced",
          tracing: { enabled: true }
        )
        expect(workflow.tracing.enabled).to eq(true)
      end

      it "creates fully configured workflow" do
        workflow = described_class.new(
          id: "wf_full",
          state_variables: { "config" => "production" },
          tracing: { enabled: true },
          version: "2.1.0"
        )
        expect(workflow.id).to eq("wf_full")
        expect(workflow.state_variables).to eq({ "config" => "production" })
        expect(workflow.tracing.enabled).to eq(true)
        expect(workflow.version).to eq("2.1.0")
      end
    end
  end
end

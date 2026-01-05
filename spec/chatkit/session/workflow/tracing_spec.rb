# frozen_string_literal: true

RSpec.describe ChatKit::Session::Workflow::Tracing do
  describe ".new" do
    context "when no arguments are provided" do
      it "initializes with default enabled value" do
        instance = described_class.new
        expect(instance.enabled).to eq(ChatKit::Session::Defaults::ENABLED)
      end
    end

    context "when enabled is provided" do
      it "initializes with true value" do
        instance = described_class.new(enabled: true)
        expect(instance.enabled).to be(true)
      end

      it "initializes with false value" do
        instance = described_class.new(enabled: false)
        expect(instance.enabled).to be(false)
      end

      it "accepts nil value" do
        instance = described_class.new(enabled: nil)
        expect(instance.enabled).to be_nil
      end
    end
  end

  describe ".build" do
    context "when no arguments are provided" do
      it "creates instance with nil enabled value" do
        instance = described_class.build
        expect(instance.enabled).to be_nil
      end
    end

    context "when enabled is provided" do
      it "creates instance with true value" do
        instance = described_class.build(enabled: true)
        expect(instance.enabled).to be(true)
      end

      it "creates instance with false value" do
        instance = described_class.build(enabled: false)
        expect(instance.enabled).to be(false)
      end

      it "creates instance with nil value" do
        instance = described_class.build(enabled: nil)
        expect(instance.enabled).to be_nil
      end
    end

    it "returns an instance of Tracing" do
      instance = described_class.build
      expect(instance).to be_a(described_class)
    end
  end

  describe ".deserialize" do
    context "when data is nil" do
      it "initializes with nil enabled value" do
        instance = described_class.deserialize(nil)
        expect(instance.enabled).to be_nil
      end

      it "returns an instance of Tracing" do
        instance = described_class.deserialize(nil)
        expect(instance).to be_a(described_class)
      end
    end

    context "when data is an empty hash" do
      it "initializes with nil enabled value" do
        instance = described_class.deserialize({})
        expect(instance.enabled).to be_nil
      end
    end

    context "when data contains enabled key" do
      it "deserializes with true value" do
        data = { "enabled" => true }
        instance = described_class.deserialize(data)
        expect(instance.enabled).to be(true)
      end

      it "deserializes with false value" do
        data = { "enabled" => false }
        instance = described_class.deserialize(data)
        expect(instance.enabled).to be(false)
      end

      it "deserializes with nil value" do
        data = { "enabled" => nil }
        instance = described_class.deserialize(data)
        expect(instance.enabled).to be_nil
      end
    end

    context "when data contains nested keys" do
      it "extracts enabled using dig" do
        data = { "enabled" => true, "other_key" => "value" }
        instance = described_class.deserialize(data)
        expect(instance.enabled).to be(true)
      end
    end

    it "returns an instance of Tracing" do
      instance = described_class.deserialize({ "enabled" => true })
      expect(instance).to be_a(described_class)
    end
  end

  describe "#serialize" do
    context "when enabled is true" do
      it "serializes to hash with enabled key" do
        instance = described_class.new(enabled: true)
        result = instance.serialize
        expect(result).to eq({ enabled: true })
      end
    end

    context "when enabled is false" do
      it "serializes to hash with enabled key" do
        instance = described_class.new(enabled: false)
        result = instance.serialize
        expect(result).to eq({ enabled: false })
      end
    end

    context "when enabled is nil" do
      it "serializes to empty hash (compacts nil values)" do
        instance = described_class.new(enabled: nil)
        result = instance.serialize
        expect(result).to eq({})
      end
    end

    context "when enabled is default value" do
      it "serializes to hash with default enabled value" do
        instance = described_class.new
        result = instance.serialize
        expect(result).to eq({ enabled: ChatKit::Session::Defaults::ENABLED })
      end
    end

    it "returns a hash" do
      instance = described_class.new(enabled: true)
      result = instance.serialize
      expect(result).to be_a(Hash)
    end
  end

  describe "attribute accessors" do
    let(:instance) { described_class.new }

    describe "#enabled" do
      it "allows reading the enabled value" do
        expect(instance.enabled).to eq(ChatKit::Session::Defaults::ENABLED)
      end

      it "allows writing true value" do
        instance.enabled = true
        expect(instance.enabled).to be(true)
      end

      it "allows writing false value" do
        instance.enabled = false
        expect(instance.enabled).to be(false)
      end

      it "allows writing nil value" do
        instance.enabled = nil
        expect(instance.enabled).to be_nil
      end
    end
  end

  describe "integration with FactoryBot" do
    context "using default factory" do
      it "creates valid instance" do
        instance = build(:tracing)
        expect(instance).to be_a(described_class)
        expect(instance.enabled).to be(true)
      end
    end

    context "using :enabled trait" do
      it "creates instance with enabled true" do
        instance = build(:tracing, :enabled)
        expect(instance.enabled).to be(true)
      end
    end

    context "using :disabled trait" do
      it "creates instance with enabled false" do
        instance = build(:tracing, :disabled)
        expect(instance.enabled).to be(false)
      end
    end

    context "using :nil_enabled trait" do
      it "creates instance with nil enabled" do
        instance = build(:tracing, :nil_enabled)
        expect(instance.enabled).to be_nil
      end
    end

    context "using :default_enabled trait" do
      it "creates instance with default enabled value" do
        instance = build(:tracing, :default_enabled)
        expect(instance.enabled).to eq(ChatKit::Session::Defaults::ENABLED)
      end
    end

    context "overriding enabled value" do
      it "allows custom enabled value" do
        instance = build(:tracing, enabled: false)
        expect(instance.enabled).to be(false)
      end
    end
  end

  describe "round-trip serialization" do
    it "maintains data integrity when serializing and deserializing with true" do
      original = described_class.new(enabled: true)
      serialized = original.serialize
      deserialized = described_class.deserialize(serialized.transform_keys(&:to_s))
      expect(deserialized.enabled).to eq(original.enabled)
    end

    it "maintains data integrity when serializing and deserializing with false" do
      original = described_class.new(enabled: false)
      serialized = original.serialize
      deserialized = described_class.deserialize(serialized.transform_keys(&:to_s))
      expect(deserialized.enabled).to eq(original.enabled)
    end

    it "handles nil values in round-trip" do
      original = described_class.new(enabled: nil)
      serialized = original.serialize
      deserialized = described_class.deserialize(serialized.transform_keys(&:to_s))
      expect(deserialized.enabled).to eq(original.enabled)
    end
  end

  describe "edge cases" do
    context "when modifying enabled after initialization" do
      it "allows toggling enabled state" do
        instance = described_class.new(enabled: true)
        expect(instance.enabled).to be(true)

        instance.enabled = false
        expect(instance.enabled).to be(false)

        instance.enabled = true
        expect(instance.enabled).to be(true)
      end
    end

    context "when serializing multiple times" do
      it "produces consistent results" do
        instance = described_class.new(enabled: true)
        first_serialization = instance.serialize
        second_serialization = instance.serialize
        expect(first_serialization).to eq(second_serialization)
      end
    end

    context "when deserializing with unexpected data types" do
      it "handles string values in hash" do
        data = { "enabled" => "true" }
        instance = described_class.deserialize(data)
        expect(instance.enabled).to eq("true")
      end

      it "handles integer values in hash" do
        data = { "enabled" => 1 }
        instance = described_class.deserialize(data)
        expect(instance.enabled).to eq(1)
      end

      it "handles zero as false-like value" do
        data = { "enabled" => 0 }
        instance = described_class.deserialize(data)
        expect(instance.enabled).to eq(0)
      end
    end

    context "when modifying after serialization" do
      it "subsequent serializations reflect modifications" do
        instance = described_class.new(enabled: true)
        first_result = instance.serialize
        expect(first_result[:enabled]).to be(true)

        instance.enabled = false
        second_result = instance.serialize
        expect(second_result[:enabled]).to be(false)
      end
    end
  end

  describe "constants and defaults" do
    it "uses Session::Create::Defaults::ENABLED as default value" do
      instance = described_class.new
      expect(instance.enabled).to eq(ChatKit::Session::Defaults::ENABLED)
    end

    it "Session::Create::Defaults::ENABLED is true" do
      expect(ChatKit::Session::Defaults::ENABLED).to be(true)
    end
  end

  describe "documentation compliance" do
    context "according to the class documentation" do
      it "tracing is enabled by default" do
        instance = described_class.new
        expect(instance.enabled).to be(true)
      end
    end
  end
end

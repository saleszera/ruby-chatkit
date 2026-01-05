# frozen_string_literal: true

RSpec.describe ChatKit::Session::ChatKitConfiguration::History do
  describe ".new" do
    context "when no arguments are provided" do
      it "initializes with default enabled value and nil recent_threads" do
        instance = described_class.new
        expect(instance.enabled).to eq(ChatKit::Session::Defaults::ENABLED)
        expect(instance.recent_threads).to be_nil
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

    context "when recent_threads is provided" do
      it "initializes with custom value" do
        instance = described_class.new(recent_threads: 50)
        expect(instance.recent_threads).to eq(50)
      end

      it "accepts zero value" do
        instance = described_class.new(recent_threads: 0)
        expect(instance.recent_threads).to eq(0)
      end

      it "accepts nil value" do
        instance = described_class.new(recent_threads: nil)
        expect(instance.recent_threads).to be_nil
      end

      it "accepts large values" do
        instance = described_class.new(recent_threads: 1000)
        expect(instance.recent_threads).to eq(1000)
      end
    end

    context "when both parameters are provided" do
      it "initializes with all custom values" do
        instance = described_class.new(enabled: false, recent_threads: 25)
        expect(instance.enabled).to be(false)
        expect(instance.recent_threads).to eq(25)
      end
    end
  end

  describe ".build" do
    context "when no arguments are provided" do
      it "creates instance with nil values" do
        instance = described_class.build
        expect(instance.enabled).to be_nil
        expect(instance.recent_threads).to be_nil
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

    context "when recent_threads is provided" do
      it "creates instance with custom value" do
        instance = described_class.build(recent_threads: 100)
        expect(instance.recent_threads).to eq(100)
      end

      it "creates instance with nil value" do
        instance = described_class.build(recent_threads: nil)
        expect(instance.recent_threads).to be_nil
      end

      it "creates instance with zero value" do
        instance = described_class.build(recent_threads: 0)
        expect(instance.recent_threads).to eq(0)
      end
    end

    context "when both parameters are provided" do
      it "creates instance with all custom values" do
        instance = described_class.build(enabled: true, recent_threads: 75)
        expect(instance.enabled).to be(true)
        expect(instance.recent_threads).to eq(75)
      end
    end

    it "returns an instance of History" do
      instance = described_class.build
      expect(instance).to be_a(described_class)
    end
  end

  describe ".deserialize" do
    context "when data is nil" do
      it "initializes with nil values for all attributes" do
        instance = described_class.deserialize(nil)
        expect(instance.enabled).to be_nil
        expect(instance.recent_threads).to be_nil
      end

      it "returns an instance of History" do
        instance = described_class.deserialize(nil)
        expect(instance).to be_a(described_class)
      end
    end

    context "when data is an empty hash" do
      it "initializes with nil values for all attributes" do
        instance = described_class.deserialize({})
        expect(instance.enabled).to be_nil
        expect(instance.recent_threads).to be_nil
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

    context "when data contains recent_threads key" do
      it "deserializes with integer value" do
        data = { "recent_threads" => 50 }
        instance = described_class.deserialize(data)
        expect(instance.recent_threads).to eq(50)
      end

      it "deserializes with nil value" do
        data = { "recent_threads" => nil }
        instance = described_class.deserialize(data)
        expect(instance.recent_threads).to be_nil
      end

      it "deserializes with zero value" do
        data = { "recent_threads" => 0 }
        instance = described_class.deserialize(data)
        expect(instance.recent_threads).to eq(0)
      end
    end

    context "when data contains all keys" do
      it "deserializes all values correctly" do
        data = {
          "enabled" => true,
          "recent_threads" => 100,
        }
        instance = described_class.deserialize(data)
        expect(instance.enabled).to be(true)
        expect(instance.recent_threads).to eq(100)
      end
    end

    context "when data contains extra keys" do
      it "extracts only relevant keys using dig" do
        data = {
          "enabled" => false,
          "recent_threads" => 75,
          "extra_key" => "ignored",
        }
        instance = described_class.deserialize(data)
        expect(instance.enabled).to be(false)
        expect(instance.recent_threads).to eq(75)
      end
    end

    it "returns an instance of History" do
      instance = described_class.deserialize({ "enabled" => true })
      expect(instance).to be_a(described_class)
    end
  end

  describe "#serialize" do
    context "when all attributes have values" do
      it "serializes to hash with all keys" do
        instance = described_class.new(enabled: true, recent_threads: 50)
        result = instance.serialize
        expect(result).to eq({
          enabled: true,
          recent_threads: 50,
        })
      end
    end

    context "when enabled is true" do
      it "serializes enabled key" do
        instance = described_class.new(enabled: true, recent_threads: 25)
        result = instance.serialize
        expect(result[:enabled]).to be(true)
      end
    end

    context "when enabled is false" do
      it "serializes enabled key" do
        instance = described_class.new(enabled: false, recent_threads: 25)
        result = instance.serialize
        expect(result[:enabled]).to be(false)
      end
    end

    context "when enabled is nil" do
      it "omits enabled from serialized hash (compacts nil values)" do
        instance = described_class.new(enabled: nil, recent_threads: 25)
        result = instance.serialize
        expect(result).not_to have_key(:enabled)
      end
    end

    context "when recent_threads is nil" do
      it "omits recent_threads from serialized hash" do
        instance = described_class.new(enabled: true, recent_threads: nil)
        result = instance.serialize
        expect(result).not_to have_key(:recent_threads)
      end
    end

    context "when recent_threads is zero" do
      it "includes recent_threads in serialized hash" do
        instance = described_class.new(enabled: true, recent_threads: 0)
        result = instance.serialize
        expect(result[:recent_threads]).to eq(0)
      end
    end

    context "when all attributes are nil" do
      it "serializes to empty hash" do
        instance = described_class.new(enabled: nil, recent_threads: nil)
        result = instance.serialize
        expect(result).to eq({})
      end
    end

    context "when using default values" do
      it "serializes with default enabled value and nil recent_threads" do
        instance = described_class.new
        result = instance.serialize
        expect(result).to eq({
          enabled: ChatKit::Session::Defaults::ENABLED,
        })
      end
    end

    it "returns a hash" do
      instance = described_class.new(enabled: true, recent_threads: 50)
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

    describe "#recent_threads" do
      it "allows reading the recent_threads value" do
        expect(instance.recent_threads).to be_nil
      end

      it "allows writing integer value" do
        instance.recent_threads = 100
        expect(instance.recent_threads).to eq(100)
      end

      it "allows writing nil value" do
        instance.recent_threads = nil
        expect(instance.recent_threads).to be_nil
      end

      it "allows writing zero value" do
        instance.recent_threads = 0
        expect(instance.recent_threads).to eq(0)
      end
    end
  end

  describe "integration with FactoryBot" do
    context "using default factory" do
      it "creates valid instance" do
        instance = build(:history)
        expect(instance).to be_a(described_class)
        expect(instance.enabled).to be(true)
        expect(instance.recent_threads).to eq(50)
      end
    end

    context "using :enabled trait" do
      it "creates instance with enabled true" do
        instance = build(:history, :enabled)
        expect(instance.enabled).to be(true)
      end
    end

    context "using :disabled trait" do
      it "creates instance with enabled false" do
        instance = build(:history, :disabled)
        expect(instance.enabled).to be(false)
      end
    end

    context "using :nil_enabled trait" do
      it "creates instance with nil enabled" do
        instance = build(:history, :nil_enabled)
        expect(instance.enabled).to be_nil
      end
    end

    context "using :default_enabled trait" do
      it "creates instance with default enabled value" do
        instance = build(:history, :default_enabled)
        expect(instance.enabled).to eq(ChatKit::Session::Defaults::ENABLED)
      end
    end

    context "using :no_thread_limit trait" do
      it "creates instance with nil recent_threads" do
        instance = build(:history, :no_thread_limit)
        expect(instance.recent_threads).to be_nil
      end
    end

    context "using :limited_threads trait" do
      it "creates instance with limited recent_threads" do
        instance = build(:history, :limited_threads)
        expect(instance.recent_threads).to eq(10)
      end
    end

    context "using :unlimited_threads trait" do
      it "creates instance with large recent_threads value" do
        instance = build(:history, :unlimited_threads)
        expect(instance.recent_threads).to eq(1000)
      end
    end

    context "using :default_recent_threads trait" do
      it "creates instance with nil recent_threads" do
        instance = build(:history, :default_recent_threads)
        expect(instance.recent_threads).to be_nil
      end
    end

    context "overriding values" do
      it "allows custom enabled value" do
        instance = build(:history, enabled: false)
        expect(instance.enabled).to be(false)
      end

      it "allows custom recent_threads value" do
        instance = build(:history, recent_threads: 200)
        expect(instance.recent_threads).to eq(200)
      end
    end

    context "combining traits" do
      it "allows combining :disabled with :limited_threads" do
        instance = build(:history, :disabled, :limited_threads)
        expect(instance.enabled).to be(false)
        expect(instance.recent_threads).to eq(10)
      end

      it "allows combining :enabled with :no_thread_limit" do
        instance = build(:history, :enabled, :no_thread_limit)
        expect(instance.enabled).to be(true)
        expect(instance.recent_threads).to be_nil
      end
    end
  end

  describe "round-trip serialization" do
    it "maintains data integrity when serializing and deserializing" do
      original = described_class.new(enabled: true, recent_threads: 50)
      serialized = original.serialize
      deserialized = described_class.deserialize(serialized.transform_keys(&:to_s))
      expect(deserialized.enabled).to eq(original.enabled)
      expect(deserialized.recent_threads).to eq(original.recent_threads)
    end

    it "maintains data integrity with false enabled" do
      original = described_class.new(enabled: false, recent_threads: 100)
      serialized = original.serialize
      deserialized = described_class.deserialize(serialized.transform_keys(&:to_s))
      expect(deserialized.enabled).to eq(original.enabled)
      expect(deserialized.recent_threads).to eq(original.recent_threads)
    end

    it "handles nil values in round-trip" do
      original = described_class.new(enabled: nil, recent_threads: nil)
      serialized = original.serialize
      deserialized = described_class.deserialize(serialized.transform_keys(&:to_s))
      expect(deserialized.enabled).to eq(original.enabled)
      expect(deserialized.recent_threads).to eq(original.recent_threads)
    end

    it "handles partial nil values in round-trip" do
      original = described_class.new(enabled: true, recent_threads: nil)
      serialized = original.serialize
      deserialized = described_class.deserialize(serialized.transform_keys(&:to_s))
      expect(deserialized.enabled).to eq(original.enabled)
      expect(deserialized.recent_threads).to eq(original.recent_threads)
    end

    it "handles zero recent_threads in round-trip" do
      original = described_class.new(enabled: true, recent_threads: 0)
      serialized = original.serialize
      deserialized = described_class.deserialize(serialized.transform_keys(&:to_s))
      expect(deserialized.enabled).to eq(original.enabled)
      expect(deserialized.recent_threads).to eq(original.recent_threads)
    end
  end

  describe "edge cases" do
    context "when modifying attributes after initialization" do
      it "allows toggling enabled state" do
        instance = described_class.new(enabled: true, recent_threads: 50)
        expect(instance.enabled).to be(true)

        instance.enabled = false
        expect(instance.enabled).to be(false)

        instance.enabled = true
        expect(instance.enabled).to be(true)
      end

      it "allows changing recent_threads value" do
        instance = described_class.new(enabled: true, recent_threads: 50)
        expect(instance.recent_threads).to eq(50)

        instance.recent_threads = 100
        expect(instance.recent_threads).to eq(100)

        instance.recent_threads = nil
        expect(instance.recent_threads).to be_nil
      end
    end

    context "when serializing multiple times" do
      it "produces consistent results" do
        instance = described_class.new(enabled: true, recent_threads: 75)
        first_serialization = instance.serialize
        second_serialization = instance.serialize
        expect(first_serialization).to eq(second_serialization)
      end
    end

    context "when deserializing with unexpected data types" do
      it "handles string values for enabled" do
        data = { "enabled" => "true" }
        instance = described_class.deserialize(data)
        expect(instance.enabled).to eq("true")
      end

      it "handles string values for recent_threads" do
        data = { "recent_threads" => "50" }
        instance = described_class.deserialize(data)
        expect(instance.recent_threads).to eq("50")
      end

      it "handles float values for recent_threads" do
        data = { "recent_threads" => 50.5 }
        instance = described_class.deserialize(data)
        expect(instance.recent_threads).to eq(50.5)
      end
    end

    context "when working with boundary values" do
      it "handles very large recent_threads values" do
        instance = described_class.new(recent_threads: 999_999)
        expect(instance.recent_threads).to eq(999_999)
        serialized = instance.serialize
        expect(serialized[:recent_threads]).to eq(999_999)
      end

      it "handles zero recent_threads" do
        instance = described_class.new(recent_threads: 0)
        expect(instance.recent_threads).to eq(0)
        serialized = instance.serialize
        expect(serialized[:recent_threads]).to eq(0)
      end

      it "handles negative recent_threads" do
        instance = described_class.new(recent_threads: -1)
        expect(instance.recent_threads).to eq(-1)
        serialized = instance.serialize
        expect(serialized[:recent_threads]).to eq(-1)
      end
    end

    context "when modifying after serialization" do
      it "subsequent serializations reflect modifications" do
        instance = described_class.new(enabled: true, recent_threads: 50)
        first_result = instance.serialize
        expect(first_result[:recent_threads]).to eq(50)

        instance.recent_threads = 100
        second_result = instance.serialize
        expect(second_result[:recent_threads]).to eq(100)
      end
    end
  end

  describe "constants and defaults" do
    it "uses Session::Create::Defaults::ENABLED as enabled default" do
      instance = described_class.new
      expect(instance.enabled).to eq(ChatKit::Session::Defaults::ENABLED)
    end

    it "uses nil as recent_threads default" do
      instance = described_class.new
      expect(instance.recent_threads).to be_nil
    end

    it "Session::Create::Defaults::ENABLED is true" do
      expect(ChatKit::Session::Defaults::ENABLED).to be(true)
    end
  end

  describe "documentation compliance" do
    context "according to the class documentation" do
      it "history is enabled by default" do
        instance = described_class.new
        expect(instance.enabled).to be(true)
      end

      it "recent_threads has no limit (nil) by default" do
        instance = described_class.new
        expect(instance.recent_threads).to be_nil
      end
    end
  end
end

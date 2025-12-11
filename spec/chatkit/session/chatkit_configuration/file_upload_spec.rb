# frozen_string_literal: true

RSpec.describe ChatKit::Session::ChatKitConfiguration::FileUpload do
  describe ".new" do
    context "when no arguments are provided" do
      it "initializes with default values" do
        instance = described_class.new
        expect(instance.enabled).to eq(ChatKit::Session::Defaults::ENABLED)
        expect(instance.max_file_size).to eq(described_class::Defaults::MAX_FILE_SIZE)
        expect(instance.max_files).to eq(described_class::Defaults::MAX_FILES)
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

    context "when max_file_size is provided" do
      it "initializes with custom value" do
        instance = described_class.new(max_file_size: 1024)
        expect(instance.max_file_size).to eq(1024)
      end

      it "accepts zero value" do
        instance = described_class.new(max_file_size: 0)
        expect(instance.max_file_size).to eq(0)
      end

      it "accepts nil value" do
        instance = described_class.new(max_file_size: nil)
        expect(instance.max_file_size).to be_nil
      end
    end

    context "when max_files is provided" do
      it "initializes with custom value" do
        instance = described_class.new(max_files: 20)
        expect(instance.max_files).to eq(20)
      end

      it "accepts zero value" do
        instance = described_class.new(max_files: 0)
        expect(instance.max_files).to eq(0)
      end

      it "accepts nil value" do
        instance = described_class.new(max_files: nil)
        expect(instance.max_files).to be_nil
      end
    end

    context "when all parameters are provided" do
      it "initializes with all custom values" do
        instance = described_class.new(enabled: false, max_file_size: 256, max_files: 15)
        expect(instance.enabled).to be(false)
        expect(instance.max_file_size).to eq(256)
        expect(instance.max_files).to eq(15)
      end
    end
  end

  describe ".build" do
    context "when no arguments are provided" do
      it "creates instance with nil values" do
        instance = described_class.build
        expect(instance.enabled).to be_nil
        expect(instance.max_file_size).to be_nil
        expect(instance.max_files).to be_nil
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

    context "when max_file_size is provided" do
      it "creates instance with custom value" do
        instance = described_class.build(max_file_size: 1024)
        expect(instance.max_file_size).to eq(1024)
      end

      it "creates instance with nil value" do
        instance = described_class.build(max_file_size: nil)
        expect(instance.max_file_size).to be_nil
      end
    end

    context "when max_files is provided" do
      it "creates instance with custom value" do
        instance = described_class.build(max_files: 25)
        expect(instance.max_files).to eq(25)
      end

      it "creates instance with nil value" do
        instance = described_class.build(max_files: nil)
        expect(instance.max_files).to be_nil
      end
    end

    context "when all parameters are provided" do
      it "creates instance with all custom values" do
        instance = described_class.build(enabled: true, max_file_size: 2048, max_files: 50)
        expect(instance.enabled).to be(true)
        expect(instance.max_file_size).to eq(2048)
        expect(instance.max_files).to eq(50)
      end
    end

    it "returns an instance of FileUpload" do
      instance = described_class.build
      expect(instance).to be_a(described_class)
    end
  end

  describe ".deserialize" do
    context "when data is nil" do
      it "initializes with nil values for all attributes" do
        instance = described_class.deserialize(nil)
        expect(instance.enabled).to be_nil
        expect(instance.max_file_size).to be_nil
        expect(instance.max_files).to be_nil
      end

      it "returns an instance of FileUpload" do
        instance = described_class.deserialize(nil)
        expect(instance).to be_a(described_class)
      end
    end

    context "when data is an empty hash" do
      it "initializes with nil values for all attributes" do
        instance = described_class.deserialize({})
        expect(instance.enabled).to be_nil
        expect(instance.max_file_size).to be_nil
        expect(instance.max_files).to be_nil
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

    context "when data contains max_file_size key" do
      it "deserializes with integer value" do
        data = { "max_file_size" => 1024 }
        instance = described_class.deserialize(data)
        expect(instance.max_file_size).to eq(1024)
      end

      it "deserializes with nil value" do
        data = { "max_file_size" => nil }
        instance = described_class.deserialize(data)
        expect(instance.max_file_size).to be_nil
      end
    end

    context "when data contains max_files key" do
      it "deserializes with integer value" do
        data = { "max_files" => 20 }
        instance = described_class.deserialize(data)
        expect(instance.max_files).to eq(20)
      end

      it "deserializes with nil value" do
        data = { "max_files" => nil }
        instance = described_class.deserialize(data)
        expect(instance.max_files).to be_nil
      end
    end

    context "when data contains all keys" do
      it "deserializes all values correctly" do
        data = {
          "enabled" => true,
          "max_file_size" => 2048,
          "max_files" => 30,
        }
        instance = described_class.deserialize(data)
        expect(instance.enabled).to be(true)
        expect(instance.max_file_size).to eq(2048)
        expect(instance.max_files).to eq(30)
      end
    end

    context "when data contains extra keys" do
      it "extracts only relevant keys using dig" do
        data = {
          "enabled" => false,
          "max_file_size" => 512,
          "max_files" => 10,
          "extra_key" => "ignored",
        }
        instance = described_class.deserialize(data)
        expect(instance.enabled).to be(false)
        expect(instance.max_file_size).to eq(512)
        expect(instance.max_files).to eq(10)
      end
    end

    it "returns an instance of FileUpload" do
      instance = described_class.deserialize({ "enabled" => true })
      expect(instance).to be_a(described_class)
    end
  end

  describe "#serialize" do
    context "when all attributes have values" do
      it "serializes to hash with all keys" do
        instance = described_class.new(enabled: true, max_file_size: 1024, max_files: 20)
        result = instance.serialize
        expect(result).to eq({
          enabled: true,
          max_file_size: 1024,
          max_files: 20,
        })
      end
    end

    context "when enabled is true" do
      it "serializes enabled key" do
        instance = described_class.new(enabled: true, max_file_size: 512, max_files: 10)
        result = instance.serialize
        expect(result[:enabled]).to be(true)
      end
    end

    context "when enabled is false" do
      it "serializes enabled key" do
        instance = described_class.new(enabled: false, max_file_size: 512, max_files: 10)
        result = instance.serialize
        expect(result[:enabled]).to be(false)
      end
    end

    context "when enabled is nil" do
      it "omits enabled from serialized hash (compacts nil values)" do
        instance = described_class.new(enabled: nil, max_file_size: 512, max_files: 10)
        result = instance.serialize
        expect(result).not_to have_key(:enabled)
      end
    end

    context "when max_file_size is nil" do
      it "omits max_file_size from serialized hash" do
        instance = described_class.new(enabled: true, max_file_size: nil, max_files: 10)
        result = instance.serialize
        expect(result).not_to have_key(:max_file_size)
      end
    end

    context "when max_files is nil" do
      it "omits max_files from serialized hash" do
        instance = described_class.new(enabled: true, max_file_size: 512, max_files: nil)
        result = instance.serialize
        expect(result).not_to have_key(:max_files)
      end
    end

    context "when all attributes are nil" do
      it "serializes to empty hash" do
        instance = described_class.new(enabled: nil, max_file_size: nil, max_files: nil)
        result = instance.serialize
        expect(result).to eq({})
      end
    end

    context "when using default values" do
      it "serializes with default values" do
        instance = described_class.new
        result = instance.serialize
        expect(result).to eq({
          enabled: ChatKit::Session::Defaults::ENABLED,
          max_file_size: described_class::Defaults::MAX_FILE_SIZE,
          max_files: described_class::Defaults::MAX_FILES,
        })
      end
    end

    it "returns a hash" do
      instance = described_class.new(enabled: true, max_file_size: 512, max_files: 10)
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

    describe "#max_file_size" do
      it "allows reading the max_file_size value" do
        expect(instance.max_file_size).to eq(described_class::Defaults::MAX_FILE_SIZE)
      end

      it "allows writing integer value" do
        instance.max_file_size = 2048
        expect(instance.max_file_size).to eq(2048)
      end

      it "allows writing nil value" do
        instance.max_file_size = nil
        expect(instance.max_file_size).to be_nil
      end

      it "allows writing zero value" do
        instance.max_file_size = 0
        expect(instance.max_file_size).to eq(0)
      end
    end

    describe "#max_files" do
      it "allows reading the max_files value" do
        expect(instance.max_files).to eq(described_class::Defaults::MAX_FILES)
      end

      it "allows writing integer value" do
        instance.max_files = 50
        expect(instance.max_files).to eq(50)
      end

      it "allows writing nil value" do
        instance.max_files = nil
        expect(instance.max_files).to be_nil
      end

      it "allows writing zero value" do
        instance.max_files = 0
        expect(instance.max_files).to eq(0)
      end
    end
  end

  describe "integration with FactoryBot" do
    context "using default factory" do
      it "creates valid instance" do
        instance = build(:file_upload)
        expect(instance).to be_a(described_class)
        expect(instance.enabled).to be(true)
        expect(instance.max_file_size).to eq(256)
        expect(instance.max_files).to eq(5)
      end
    end

    context "using :enabled trait" do
      it "creates instance with enabled true" do
        instance = build(:file_upload, :enabled)
        expect(instance.enabled).to be(true)
      end
    end

    context "using :disabled trait" do
      it "creates instance with enabled false" do
        instance = build(:file_upload, :disabled)
        expect(instance.enabled).to be(false)
      end
    end

    context "using :nil_enabled trait" do
      it "creates instance with nil enabled" do
        instance = build(:file_upload, :nil_enabled)
        expect(instance.enabled).to be_nil
      end
    end

    context "using :default_enabled trait" do
      it "creates instance with default enabled value" do
        instance = build(:file_upload, :default_enabled)
        expect(instance.enabled).to eq(ChatKit::Session::Defaults::ENABLED)
      end
    end

    context "using :large_files trait" do
      it "creates instance with large file limits" do
        instance = build(:file_upload, :large_files)
        expect(instance.max_file_size).to eq(1024)
        expect(instance.max_files).to eq(20)
      end
    end

    context "using :small_files trait" do
      it "creates instance with small file limits" do
        instance = build(:file_upload, :small_files)
        expect(instance.max_file_size).to eq(64)
        expect(instance.max_files).to eq(2)
      end
    end

    context "using :default_limits trait" do
      it "creates instance with default file limits" do
        instance = build(:file_upload, :default_limits)
        expect(instance.max_file_size).to eq(described_class::Defaults::MAX_FILE_SIZE)
        expect(instance.max_files).to eq(described_class::Defaults::MAX_FILES)
      end
    end

    context "using :nil_limits trait" do
      it "creates instance with nil file limits" do
        instance = build(:file_upload, :nil_limits)
        expect(instance.max_file_size).to be_nil
        expect(instance.max_files).to be_nil
      end
    end

    context "overriding values" do
      it "allows custom enabled value" do
        instance = build(:file_upload, enabled: false)
        expect(instance.enabled).to be(false)
      end

      it "allows custom max_file_size value" do
        instance = build(:file_upload, max_file_size: 4096)
        expect(instance.max_file_size).to eq(4096)
      end

      it "allows custom max_files value" do
        instance = build(:file_upload, max_files: 100)
        expect(instance.max_files).to eq(100)
      end
    end

    context "combining traits" do
      it "allows combining :disabled with :large_files" do
        instance = build(:file_upload, :disabled, :large_files)
        expect(instance.enabled).to be(false)
        expect(instance.max_file_size).to eq(1024)
        expect(instance.max_files).to eq(20)
      end
    end
  end

  describe "round-trip serialization" do
    it "maintains data integrity when serializing and deserializing" do
      original = described_class.new(enabled: true, max_file_size: 1024, max_files: 25)
      serialized = original.serialize
      deserialized = described_class.deserialize(serialized.transform_keys(&:to_s))
      expect(deserialized.enabled).to eq(original.enabled)
      expect(deserialized.max_file_size).to eq(original.max_file_size)
      expect(deserialized.max_files).to eq(original.max_files)
    end

    it "maintains data integrity with false enabled" do
      original = described_class.new(enabled: false, max_file_size: 512, max_files: 10)
      serialized = original.serialize
      deserialized = described_class.deserialize(serialized.transform_keys(&:to_s))
      expect(deserialized.enabled).to eq(original.enabled)
      expect(deserialized.max_file_size).to eq(original.max_file_size)
      expect(deserialized.max_files).to eq(original.max_files)
    end

    it "handles nil values in round-trip" do
      original = described_class.new(enabled: nil, max_file_size: nil, max_files: nil)
      serialized = original.serialize
      deserialized = described_class.deserialize(serialized.transform_keys(&:to_s))
      expect(deserialized.enabled).to eq(original.enabled)
      expect(deserialized.max_file_size).to eq(original.max_file_size)
      expect(deserialized.max_files).to eq(original.max_files)
    end

    it "handles partial nil values in round-trip" do
      original = described_class.new(enabled: true, max_file_size: nil, max_files: 10)
      serialized = original.serialize
      deserialized = described_class.deserialize(serialized.transform_keys(&:to_s))
      expect(deserialized.enabled).to eq(original.enabled)
      expect(deserialized.max_file_size).to eq(original.max_file_size)
      expect(deserialized.max_files).to eq(original.max_files)
    end
  end

  describe "edge cases" do
    context "when modifying attributes after initialization" do
      it "allows toggling enabled state" do
        instance = described_class.new(enabled: true, max_file_size: 512, max_files: 10)
        expect(instance.enabled).to be(true)

        instance.enabled = false
        expect(instance.enabled).to be(false)

        instance.enabled = true
        expect(instance.enabled).to be(true)
      end

      it "allows changing file size limits" do
        instance = described_class.new(enabled: true, max_file_size: 512, max_files: 10)
        expect(instance.max_file_size).to eq(512)

        instance.max_file_size = 2048
        expect(instance.max_file_size).to eq(2048)
      end

      it "allows changing file count limits" do
        instance = described_class.new(enabled: true, max_file_size: 512, max_files: 10)
        expect(instance.max_files).to eq(10)

        instance.max_files = 50
        expect(instance.max_files).to eq(50)
      end
    end

    context "when serializing multiple times" do
      it "produces consistent results" do
        instance = described_class.new(enabled: true, max_file_size: 1024, max_files: 20)
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

      it "handles string values for max_file_size" do
        data = { "max_file_size" => "1024" }
        instance = described_class.deserialize(data)
        expect(instance.max_file_size).to eq("1024")
      end

      it "handles string values for max_files" do
        data = { "max_files" => "20" }
        instance = described_class.deserialize(data)
        expect(instance.max_files).to eq("20")
      end
    end

    context "when working with boundary values" do
      it "handles very large file sizes" do
        instance = described_class.new(max_file_size: 999_999)
        expect(instance.max_file_size).to eq(999_999)
        serialized = instance.serialize
        expect(serialized[:max_file_size]).to eq(999_999)
      end

      it "handles very large file counts" do
        instance = described_class.new(max_files: 10_000)
        expect(instance.max_files).to eq(10_000)
        serialized = instance.serialize
        expect(serialized[:max_files]).to eq(10_000)
      end

      it "handles zero file size" do
        instance = described_class.new(max_file_size: 0)
        expect(instance.max_file_size).to eq(0)
        serialized = instance.serialize
        expect(serialized[:max_file_size]).to eq(0)
      end

      it "handles zero file count" do
        instance = described_class.new(max_files: 0)
        expect(instance.max_files).to eq(0)
        serialized = instance.serialize
        expect(serialized[:max_files]).to eq(0)
      end
    end
  end

  describe "constants and defaults" do
    it "has correct MAX_FILE_SIZE default" do
      expect(described_class::Defaults::MAX_FILE_SIZE).to eq(512)
    end

    it "has correct MAX_FILES default" do
      expect(described_class::Defaults::MAX_FILES).to eq(10)
    end

    it "uses Session::Create::Defaults::ENABLED as enabled default" do
      instance = described_class.new
      expect(instance.enabled).to eq(ChatKit::Session::Defaults::ENABLED)
    end

    it "uses Defaults::MAX_FILE_SIZE as max_file_size default" do
      instance = described_class.new
      expect(instance.max_file_size).to eq(described_class::Defaults::MAX_FILE_SIZE)
    end

    it "uses Defaults::MAX_FILES as max_files default" do
      instance = described_class.new
      expect(instance.max_files).to eq(described_class::Defaults::MAX_FILES)
    end
  end
end

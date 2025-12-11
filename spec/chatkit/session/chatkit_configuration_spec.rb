# frozen_string_literal: true

RSpec.describe ChatKit::Session::ChatKitConfiguration do
  describe ".new" do
    context "when no arguments are provided" do
      it "initializes all nested configurations with default values" do
        instance = described_class.new
        expect(instance.automatic_thread_titling).to be_a(described_class::AutomaticThreadTitling)
        expect(instance.file_upload).to be_a(described_class::FileUpload)
        expect(instance.history).to be_a(described_class::History)
      end
    end

    context "when hash parameters are provided" do
      it "initializes automatic_thread_titling from hash" do
        instance = described_class.new(automatic_thread_titling: { enabled: false })
        expect(instance.automatic_thread_titling).to be_a(described_class::AutomaticThreadTitling)
        expect(instance.automatic_thread_titling.enabled).to be(false)
      end

      it "initializes file_upload from hash" do
        instance = described_class.new(file_upload: { enabled: true, max_file_size: 1024, max_files: 20 })
        expect(instance.file_upload).to be_a(described_class::FileUpload)
        expect(instance.file_upload.enabled).to be(true)
        expect(instance.file_upload.max_file_size).to eq(1024)
        expect(instance.file_upload.max_files).to eq(20)
      end

      it "initializes history from hash" do
        instance = described_class.new(history: { enabled: false, recent_threads: 100 })
        expect(instance.history).to be_a(described_class::History)
        expect(instance.history.enabled).to be(false)
        expect(instance.history.recent_threads).to eq(100)
      end

      it "initializes all nested configurations from hashes" do
        instance = described_class.new(
          automatic_thread_titling: { enabled: true },
          file_upload: { enabled: false, max_file_size: 256, max_files: 5 },
          history: { enabled: true, recent_threads: 50 }
        )
        expect(instance.automatic_thread_titling.enabled).to be(true)
        expect(instance.file_upload.enabled).to be(false)
        expect(instance.file_upload.max_file_size).to eq(256)
        expect(instance.history.enabled).to be(true)
        expect(instance.history.recent_threads).to eq(50)
      end
    end

    context "when object parameters are provided" do
      it "accepts AutomaticThreadTitling object" do
        auto_title = described_class::AutomaticThreadTitling.new(enabled: false)
        instance = described_class.new(automatic_thread_titling: auto_title)
        expect(instance.automatic_thread_titling).to eq(auto_title)
      end

      it "accepts FileUpload object" do
        file_upload = described_class::FileUpload.new(enabled: true, max_file_size: 2048, max_files: 30)
        instance = described_class.new(file_upload:)
        expect(instance.file_upload).to eq(file_upload)
      end

      it "accepts History object" do
        history = described_class::History.new(enabled: false, recent_threads: 25)
        instance = described_class.new(history:)
        expect(instance.history).to eq(history)
      end

      it "accepts all objects" do
        auto_title = described_class::AutomaticThreadTitling.new(enabled: true)
        file_upload = described_class::FileUpload.new(enabled: false, max_file_size: 512, max_files: 10)
        history = described_class::History.new(enabled: true, recent_threads: nil)

        instance = described_class.new(
          automatic_thread_titling: auto_title,
          file_upload:,
          history:
        )

        expect(instance.automatic_thread_titling).to eq(auto_title)
        expect(instance.file_upload).to eq(file_upload)
        expect(instance.history).to eq(history)
      end
    end

    context "when nil parameters are provided" do
      it "initializes with nil automatic_thread_titling" do
        instance = described_class.new(automatic_thread_titling: nil)
        expect(instance.automatic_thread_titling).to be_a(described_class::AutomaticThreadTitling)
      end

      it "initializes with nil file_upload" do
        instance = described_class.new(file_upload: nil)
        expect(instance.file_upload).to be_a(described_class::FileUpload)
      end

      it "initializes with nil history" do
        instance = described_class.new(history: nil)
        expect(instance.history).to be_a(described_class::History)
      end
    end

    context "when empty hash parameters are provided" do
      it "initializes with empty automatic_thread_titling hash" do
        instance = described_class.new(automatic_thread_titling: {})
        expect(instance.automatic_thread_titling).to be_a(described_class::AutomaticThreadTitling)
      end

      it "initializes with empty file_upload hash" do
        instance = described_class.new(file_upload: {})
        expect(instance.file_upload).to be_a(described_class::FileUpload)
      end

      it "initializes with empty history hash" do
        instance = described_class.new(history: {})
        expect(instance.history).to be_a(described_class::History)
      end
    end
  end

  describe ".build" do
    context "when no arguments are provided" do
      it "creates instance with default nested configurations" do
        instance = described_class.build
        expect(instance.automatic_thread_titling).to be_a(described_class::AutomaticThreadTitling)
        expect(instance.file_upload).to be_a(described_class::FileUpload)
        expect(instance.history).to be_a(described_class::History)
      end
    end

    context "when hash parameters are provided" do
      it "builds with automatic_thread_titling hash" do
        instance = described_class.build(automatic_thread_titling: { enabled: false })
        expect(instance.automatic_thread_titling.enabled).to be(false)
      end

      it "builds with file_upload hash" do
        instance = described_class.build(file_upload: { enabled: true, max_file_size: 128, max_files: 3 })
        expect(instance.file_upload.enabled).to be(true)
        expect(instance.file_upload.max_file_size).to eq(128)
        expect(instance.file_upload.max_files).to eq(3)
      end

      it "builds with history hash" do
        instance = described_class.build(history: { enabled: true, recent_threads: 75 })
        expect(instance.history.enabled).to be(true)
        expect(instance.history.recent_threads).to eq(75)
      end

      it "builds with all hash parameters" do
        instance = described_class.build(
          automatic_thread_titling: { enabled: false },
          file_upload: { enabled: true, max_file_size: 4096, max_files: 100 },
          history: { enabled: false, recent_threads: 10 }
        )
        expect(instance.automatic_thread_titling.enabled).to be(false)
        expect(instance.file_upload.enabled).to be(true)
        expect(instance.history.enabled).to be(false)
      end
    end

    it "returns an instance of ChatKitConfiguration" do
      instance = described_class.build
      expect(instance).to be_a(described_class)
    end
  end

  describe ".deserialize" do
    context "when data is nil" do
      it "initializes with default nested configurations" do
        instance = described_class.deserialize(nil)
        expect(instance.automatic_thread_titling).to be_a(described_class::AutomaticThreadTitling)
        expect(instance.file_upload).to be_a(described_class::FileUpload)
        expect(instance.history).to be_a(described_class::History)
      end
    end

    context "when data is an empty hash" do
      it "initializes with default nested configurations" do
        instance = described_class.deserialize({})
        expect(instance.automatic_thread_titling).to be_a(described_class::AutomaticThreadTitling)
        expect(instance.file_upload).to be_a(described_class::FileUpload)
        expect(instance.history).to be_a(described_class::History)
      end
    end

    context "when data contains nested configurations" do
      it "deserializes automatic_thread_titling" do
        data = { "automatic_thread_titling" => { "enabled" => false } }
        instance = described_class.deserialize(data)
        expect(instance.automatic_thread_titling.enabled).to be(false)
      end

      it "deserializes file_upload" do
        data = {
          "file_upload" => {
            "enabled" => true,
            "max_file_size" => 2048,
            "max_files" => 50,
          },
        }
        instance = described_class.deserialize(data)
        expect(instance.file_upload.enabled).to be(true)
        expect(instance.file_upload.max_file_size).to eq(2048)
        expect(instance.file_upload.max_files).to eq(50)
      end

      it "deserializes history" do
        data = {
          "history" => {
            "enabled" => false,
            "recent_threads" => 200,
          },
        }
        instance = described_class.deserialize(data)
        expect(instance.history.enabled).to be(false)
        expect(instance.history.recent_threads).to eq(200)
      end

      it "deserializes all nested configurations" do
        data = {
          "automatic_thread_titling" => { "enabled" => true },
          "file_upload" => {
            "enabled" => false,
            "max_file_size" => 1024,
            "max_files" => 15,
          },
          "history" => {
            "enabled" => true,
            "recent_threads" => 100,
          },
        }
        instance = described_class.deserialize(data)
        expect(instance.automatic_thread_titling.enabled).to be(true)
        expect(instance.file_upload.enabled).to be(false)
        expect(instance.file_upload.max_file_size).to eq(1024)
        expect(instance.file_upload.max_files).to eq(15)
        expect(instance.history.enabled).to be(true)
        expect(instance.history.recent_threads).to eq(100)
      end
    end

    context "when data contains extra keys" do
      it "ignores extra keys" do
        data = {
          "automatic_thread_titling" => { "enabled" => true },
          "file_upload" => { "enabled" => false },
          "history" => { "enabled" => true },
          "extra_key" => "ignored",
        }
        instance = described_class.deserialize(data)
        expect(instance.automatic_thread_titling.enabled).to be(true)
        expect(instance.file_upload.enabled).to be(false)
        expect(instance.history.enabled).to be(true)
      end
    end

    it "returns an instance of ChatKitConfiguration" do
      instance = described_class.deserialize({ "automatic_thread_titling" => { "enabled" => true } })
      expect(instance).to be_a(described_class)
    end
  end

  describe "#serialize" do
    context "when all nested configurations have values" do
      it "serializes all nested configurations" do
        instance = described_class.new(
          automatic_thread_titling: { enabled: true },
          file_upload: { enabled: false, max_file_size: 512, max_files: 10 },
          history: { enabled: true, recent_threads: 50 }
        )
        result = instance.serialize
        expect(result[:automatic_thread_titling]).to eq({ enabled: true })
        expect(result[:file_upload]).to eq({ enabled: false, max_file_size: 512, max_files: 10 })
        expect(result[:history]).to eq({ enabled: true, recent_threads: 50 })
      end
    end

    context "when nested configurations have nil values" do
      it "omits nil values from serialized hash" do
        instance = described_class.new(
          automatic_thread_titling: { enabled: nil },
          file_upload: { enabled: nil, max_file_size: nil, max_files: nil },
          history: { enabled: nil, recent_threads: nil }
        )
        result = instance.serialize
        expect(result[:automatic_thread_titling]).to eq({})
        expect(result[:file_upload]).to eq({})
        expect(result[:history]).to eq({})
      end
    end

    context "when nested configurations have mixed values" do
      it "serializes only non-nil values" do
        instance = described_class.new(
          automatic_thread_titling: { enabled: true },
          file_upload: { enabled: nil, max_file_size: 1024, max_files: nil },
          history: { enabled: false, recent_threads: nil }
        )
        result = instance.serialize
        expect(result[:automatic_thread_titling]).to eq({ enabled: true })
        expect(result[:file_upload]).to eq({ max_file_size: 1024 })
        expect(result[:history]).to eq({ enabled: false })
      end
    end

    it "returns a hash" do
      instance = described_class.new
      result = instance.serialize
      expect(result).to be_a(Hash)
    end
  end

  describe "attribute accessors" do
    let(:instance) { described_class.new }

    describe "#automatic_thread_titling" do
      it "allows reading the automatic_thread_titling value" do
        expect(instance.automatic_thread_titling).to be_a(described_class::AutomaticThreadTitling)
      end

      it "allows writing AutomaticThreadTitling object" do
        new_config = described_class::AutomaticThreadTitling.new(enabled: false)
        instance.automatic_thread_titling = new_config
        expect(instance.automatic_thread_titling).to eq(new_config)
      end
    end

    describe "#file_upload" do
      it "allows reading the file_upload value" do
        expect(instance.file_upload).to be_a(described_class::FileUpload)
      end

      it "allows writing FileUpload object" do
        new_config = described_class::FileUpload.new(enabled: false, max_file_size: 128, max_files: 2)
        instance.file_upload = new_config
        expect(instance.file_upload).to eq(new_config)
      end
    end

    describe "#history" do
      it "allows reading the history value" do
        expect(instance.history).to be_a(described_class::History)
      end

      it "allows writing History object" do
        new_config = described_class::History.new(enabled: false, recent_threads: 25)
        instance.history = new_config
        expect(instance.history).to eq(new_config)
      end
    end
  end

  describe "integration with FactoryBot" do
    context "using default factory" do
      it "creates valid instance" do
        instance = build(:chatkit_configuration)
        expect(instance).to be_a(described_class)
        expect(instance.automatic_thread_titling.enabled).to be(true)
        expect(instance.file_upload.enabled).to be(true)
        expect(instance.history.enabled).to be(true)
      end
    end

    context "using :all_enabled trait" do
      it "creates instance with all features enabled" do
        instance = build(:chatkit_configuration, :all_enabled)
        expect(instance.automatic_thread_titling.enabled).to be(true)
        expect(instance.file_upload.enabled).to be(true)
        expect(instance.file_upload.max_file_size).to eq(512)
        expect(instance.file_upload.max_files).to eq(10)
        expect(instance.history.enabled).to be(true)
        expect(instance.history.recent_threads).to eq(100)
      end
    end

    context "using :all_disabled trait" do
      it "creates instance with all features disabled" do
        instance = build(:chatkit_configuration, :all_disabled)
        expect(instance.automatic_thread_titling.enabled).to be(false)
        expect(instance.file_upload.enabled).to be(false)
        expect(instance.history.enabled).to be(false)
      end
    end

    context "using :mixed_settings trait" do
      it "creates instance with mixed settings" do
        instance = build(:chatkit_configuration, :mixed_settings)
        expect(instance.automatic_thread_titling.enabled).to be(true)
        expect(instance.file_upload.enabled).to be(false)
        expect(instance.history.enabled).to be(true)
      end
    end

    context "using :minimal_config trait" do
      it "creates instance with minimal configuration" do
        instance = build(:chatkit_configuration, :minimal_config)
        expect(instance.automatic_thread_titling.enabled).to be_nil
        expect(instance.file_upload.enabled).to be_nil
        expect(instance.history.enabled).to be_nil
      end
    end

    context "using :with_objects trait" do
      it "creates instance with object parameters" do
        instance = build(:chatkit_configuration, :with_objects)
        expect(instance.automatic_thread_titling).to be_a(described_class::AutomaticThreadTitling)
        expect(instance.file_upload).to be_a(described_class::FileUpload)
        expect(instance.history).to be_a(described_class::History)
      end
    end

    context "overriding values" do
      it "allows custom automatic_thread_titling params" do
        instance = build(:chatkit_configuration, automatic_thread_titling_params: { enabled: false })
        expect(instance.automatic_thread_titling.enabled).to be(false)
      end

      it "allows custom file_upload params" do
        instance = build(:chatkit_configuration,
          file_upload_params: { enabled: false, max_file_size: 64, max_files: 1 })
        expect(instance.file_upload.enabled).to be(false)
        expect(instance.file_upload.max_file_size).to eq(64)
        expect(instance.file_upload.max_files).to eq(1)
      end

      it "allows custom history params" do
        instance = build(:chatkit_configuration, history_params: { enabled: false, recent_threads: 10 })
        expect(instance.history.enabled).to be(false)
        expect(instance.history.recent_threads).to eq(10)
      end
    end
  end

  describe "round-trip serialization" do
    it "maintains data integrity when serializing and deserializing" do
      original = described_class.new(
        automatic_thread_titling: { enabled: true },
        file_upload: { enabled: false, max_file_size: 1024, max_files: 20 },
        history: { enabled: true, recent_threads: 75 }
      )
      serialized = original.serialize
      # The serialize method returns symbols as keys, but deserialize expects strings
      string_keyed = JSON.parse(serialized.to_json)
      deserialized = described_class.deserialize(string_keyed)

      expect(deserialized.automatic_thread_titling.enabled).to eq(original.automatic_thread_titling.enabled)
      expect(deserialized.file_upload.enabled).to eq(original.file_upload.enabled)
      expect(deserialized.file_upload.max_file_size).to eq(original.file_upload.max_file_size)
      expect(deserialized.file_upload.max_files).to eq(original.file_upload.max_files)
      expect(deserialized.history.enabled).to eq(original.history.enabled)
      expect(deserialized.history.recent_threads).to eq(original.history.recent_threads)
    end

    it "handles nil values in round-trip" do
      original = described_class.new(
        automatic_thread_titling: { enabled: nil },
        file_upload: { enabled: nil, max_file_size: nil, max_files: nil },
        history: { enabled: nil, recent_threads: nil }
      )
      serialized = original.serialize
      string_keyed = JSON.parse(serialized.to_json)
      deserialized = described_class.deserialize(string_keyed)

      expect(deserialized.automatic_thread_titling.enabled).to be_nil
      expect(deserialized.file_upload.enabled).to be_nil
      expect(deserialized.history.enabled).to be_nil
    end
  end

  describe "edge cases" do
    context "when modifying nested configurations after initialization" do
      it "allows modifying automatic_thread_titling" do
        instance = described_class.new(automatic_thread_titling: { enabled: true })
        expect(instance.automatic_thread_titling.enabled).to be(true)

        instance.automatic_thread_titling.enabled = false
        expect(instance.automatic_thread_titling.enabled).to be(false)
      end

      it "allows modifying file_upload" do
        instance = described_class.new(file_upload: { enabled: true, max_file_size: 512, max_files: 10 })
        expect(instance.file_upload.max_file_size).to eq(512)

        instance.file_upload.max_file_size = 2048
        expect(instance.file_upload.max_file_size).to eq(2048)
      end

      it "allows modifying history" do
        instance = described_class.new(history: { enabled: true, recent_threads: 50 })
        expect(instance.history.recent_threads).to eq(50)

        instance.history.recent_threads = 100
        expect(instance.history.recent_threads).to eq(100)
      end
    end

    context "when serializing multiple times" do
      it "produces consistent results" do
        instance = described_class.new(
          automatic_thread_titling: { enabled: true },
          file_upload: { enabled: false, max_file_size: 256, max_files: 5 },
          history: { enabled: true, recent_threads: 25 }
        )
        first_serialization = instance.serialize
        second_serialization = instance.serialize
        expect(first_serialization).to eq(second_serialization)
      end
    end

    context "when replacing entire nested configuration objects" do
      it "allows replacing automatic_thread_titling object" do
        instance = described_class.new(automatic_thread_titling: { enabled: true })
        new_config = described_class::AutomaticThreadTitling.new(enabled: false)
        instance.automatic_thread_titling = new_config
        expect(instance.automatic_thread_titling).to eq(new_config)
      end

      it "serialization reflects replaced objects" do
        instance = described_class.new(automatic_thread_titling: { enabled: true })
        new_config = described_class::AutomaticThreadTitling.new(enabled: false)
        instance.automatic_thread_titling = new_config
        result = instance.serialize
        expect(result[:automatic_thread_titling]).to eq({ enabled: false })
      end
    end
  end

  describe "private methods" do
    describe "#setup_automatic_thread_titling" do
      it "returns the object if it's already an AutomaticThreadTitling instance" do
        auto_title = described_class::AutomaticThreadTitling.new(enabled: false)
        instance = described_class.new(automatic_thread_titling: auto_title)
        expect(instance.automatic_thread_titling).to eq(auto_title)
      end

      it "builds from hash if parameter is a hash" do
        instance = described_class.new(automatic_thread_titling: { enabled: false })
        expect(instance.automatic_thread_titling).to be_a(described_class::AutomaticThreadTitling)
        expect(instance.automatic_thread_titling.enabled).to be(false)
      end

      it "handles nil parameter" do
        instance = described_class.new(automatic_thread_titling: nil)
        expect(instance.automatic_thread_titling).to be_a(described_class::AutomaticThreadTitling)
      end
    end

    describe "#setup_file_upload" do
      it "returns the object if it's already a FileUpload instance" do
        file_upload = described_class::FileUpload.new(enabled: false, max_file_size: 128, max_files: 2)
        instance = described_class.new(file_upload:)
        expect(instance.file_upload).to eq(file_upload)
      end

      it "builds from hash if parameter is a hash" do
        instance = described_class.new(file_upload: { enabled: false, max_file_size: 256, max_files: 5 })
        expect(instance.file_upload).to be_a(described_class::FileUpload)
        expect(instance.file_upload.enabled).to be(false)
        expect(instance.file_upload.max_file_size).to eq(256)
      end

      it "handles nil parameter" do
        instance = described_class.new(file_upload: nil)
        expect(instance.file_upload).to be_a(described_class::FileUpload)
      end
    end

    describe "#setup_history" do
      it "returns the object if it's already a History instance" do
        history = described_class::History.new(enabled: false, recent_threads: 25)
        instance = described_class.new(history:)
        expect(instance.history).to eq(history)
      end

      it "builds from hash if parameter is a hash" do
        instance = described_class.new(history: { enabled: false, recent_threads: 50 })
        expect(instance.history).to be_a(described_class::History)
        expect(instance.history.enabled).to be(false)
        expect(instance.history.recent_threads).to eq(50)
      end

      it "handles nil parameter" do
        instance = described_class.new(history: nil)
        expect(instance.history).to be_a(described_class::History)
      end
    end
  end
end

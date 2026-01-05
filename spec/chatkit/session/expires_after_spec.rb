# frozen_string_literal: true

RSpec.describe ChatKit::Session::ExpiresAfter do
  describe ".new" do
    context "when both required arguments are provided" do
      it "initializes with anchor and seconds" do
        instance = described_class.new(anchor: "creation", seconds: 600)
        expect(instance.anchor).to eq("creation")
        expect(instance.seconds).to eq(600)
      end

      it "accepts last_activity anchor" do
        instance = described_class.new(anchor: "last_activity", seconds: 3600)
        expect(instance.anchor).to eq("last_activity")
        expect(instance.seconds).to eq(3600)
      end

      it "accepts custom anchor values" do
        instance = described_class.new(anchor: "custom_timestamp", seconds: 1200)
        expect(instance.anchor).to eq("custom_timestamp")
        expect(instance.seconds).to eq(1200)
      end

      it "accepts various second values" do
        instance = described_class.new(anchor: "creation", seconds: 86_400)
        expect(instance.seconds).to eq(86_400)
      end

      it "accepts zero seconds" do
        instance = described_class.new(anchor: "creation", seconds: 0)
        expect(instance.seconds).to eq(0)
      end

      it "accepts large second values" do
        instance = described_class.new(anchor: "creation", seconds: 999_999)
        expect(instance.seconds).to eq(999_999)
      end
    end

    context "when arguments are missing" do
      it "raises ArgumentError when anchor is missing" do
        expect { described_class.new(seconds: 600) }.to raise_error(ArgumentError)
      end

      it "raises ArgumentError when seconds is missing" do
        expect { described_class.new(anchor: "creation") }.to raise_error(ArgumentError)
      end

      it "raises ArgumentError when both are missing" do
        expect { described_class.new }.to raise_error(ArgumentError)
      end
    end

    context "when nil values are provided" do
      it "accepts nil anchor" do
        instance = described_class.new(anchor: nil, seconds: 600)
        expect(instance.anchor).to be_nil
      end

      it "accepts nil seconds" do
        instance = described_class.new(anchor: "creation", seconds: nil)
        expect(instance.seconds).to be_nil
      end

      it "accepts both nil values" do
        instance = described_class.new(anchor: nil, seconds: nil)
        expect(instance.anchor).to be_nil
        expect(instance.seconds).to be_nil
      end
    end
  end

  describe ".build" do
    context "when both required arguments are provided" do
      it "builds with anchor and seconds" do
        instance = described_class.build(anchor: "creation", seconds: 600)
        expect(instance.anchor).to eq("creation")
        expect(instance.seconds).to eq(600)
      end

      it "builds with last_activity anchor" do
        instance = described_class.build(anchor: "last_activity", seconds: 1800)
        expect(instance.anchor).to eq("last_activity")
        expect(instance.seconds).to eq(1800)
      end

      it "builds with custom values" do
        instance = described_class.build(anchor: "custom", seconds: 7200)
        expect(instance.anchor).to eq("custom")
        expect(instance.seconds).to eq(7200)
      end
    end

    context "when arguments are missing" do
      it "raises ArgumentError when anchor is missing" do
        expect { described_class.build(seconds: 600) }.to raise_error(ArgumentError)
      end

      it "raises ArgumentError when seconds is missing" do
        expect { described_class.build(anchor: "creation") }.to raise_error(ArgumentError)
      end

      it "raises ArgumentError when both are missing" do
        expect { described_class.build }.to raise_error(ArgumentError)
      end
    end

    it "returns an instance of ExpiresAfter" do
      instance = described_class.build(anchor: "creation", seconds: 600)
      expect(instance).to be_a(described_class)
    end
  end

  describe "#serialize" do
    context "when both attributes have values" do
      it "serializes to hash with both keys" do
        instance = described_class.new(anchor: "creation", seconds: 600)
        result = instance.serialize
        expect(result).to eq({ anchor: "creation", seconds: 600 })
      end

      it "serializes with last_activity anchor" do
        instance = described_class.new(anchor: "last_activity", seconds: 3600)
        result = instance.serialize
        expect(result).to eq({ anchor: "last_activity", seconds: 3600 })
      end

      it "serializes with large seconds value" do
        instance = described_class.new(anchor: "creation", seconds: 86_400)
        result = instance.serialize
        expect(result).to eq({ anchor: "creation", seconds: 86_400 })
      end
    end

    context "when attributes have nil values" do
      it "omits nil anchor from serialized hash" do
        instance = described_class.new(anchor: nil, seconds: 600)
        result = instance.serialize
        expect(result).to eq({ seconds: 600 })
        expect(result).not_to have_key(:anchor)
      end

      it "omits nil seconds from serialized hash" do
        instance = described_class.new(anchor: "creation", seconds: nil)
        result = instance.serialize
        expect(result).to eq({ anchor: "creation" })
        expect(result).not_to have_key(:seconds)
      end

      it "serializes to empty hash when both are nil" do
        instance = described_class.new(anchor: nil, seconds: nil)
        result = instance.serialize
        expect(result).to eq({})
      end
    end

    context "when attributes have edge case values" do
      it "includes zero seconds in serialized hash" do
        instance = described_class.new(anchor: "creation", seconds: 0)
        result = instance.serialize
        expect(result[:seconds]).to eq(0)
      end

      it "includes empty string anchor in serialized hash" do
        instance = described_class.new(anchor: "", seconds: 600)
        result = instance.serialize
        expect(result[:anchor]).to eq("")
      end
    end

    it "returns a hash" do
      instance = described_class.new(anchor: "creation", seconds: 600)
      result = instance.serialize
      expect(result).to be_a(Hash)
    end
  end

  describe "attribute accessors" do
    let(:instance) { described_class.new(anchor: "creation", seconds: 600) }

    describe "#anchor" do
      it "allows reading the anchor value" do
        expect(instance.anchor).to eq("creation")
      end

      it "allows writing string value" do
        instance.anchor = "last_activity"
        expect(instance.anchor).to eq("last_activity")
      end

      it "allows writing nil value" do
        instance.anchor = nil
        expect(instance.anchor).to be_nil
      end

      it "allows writing custom values" do
        instance.anchor = "custom_timestamp"
        expect(instance.anchor).to eq("custom_timestamp")
      end
    end

    describe "#seconds" do
      it "allows reading the seconds value" do
        expect(instance.seconds).to eq(600)
      end

      it "allows writing integer value" do
        instance.seconds = 3600
        expect(instance.seconds).to eq(3600)
      end

      it "allows writing nil value" do
        instance.seconds = nil
        expect(instance.seconds).to be_nil
      end

      it "allows writing zero value" do
        instance.seconds = 0
        expect(instance.seconds).to eq(0)
      end

      it "allows writing large values" do
        instance.seconds = 999_999
        expect(instance.seconds).to eq(999_999)
      end
    end
  end

  describe "integration with FactoryBot" do
    context "using default factory" do
      it "creates valid instance" do
        instance = build(:expires_after)
        expect(instance).to be_a(described_class)
        expect(instance.anchor).to eq("creation")
        expect(instance.seconds).to eq(600)
      end
    end

    context "using :short_expiry trait" do
      it "creates instance with short expiry" do
        instance = build(:expires_after, :short_expiry)
        expect(instance.seconds).to eq(60)
      end
    end

    context "using :long_expiry trait" do
      it "creates instance with long expiry" do
        instance = build(:expires_after, :long_expiry)
        expect(instance.seconds).to eq(3600)
      end
    end

    context "using :ten_minutes trait" do
      it "creates instance with ten minutes expiry" do
        instance = build(:expires_after, :ten_minutes)
        expect(instance.seconds).to eq(600)
      end
    end

    context "using :one_hour trait" do
      it "creates instance with one hour expiry" do
        instance = build(:expires_after, :one_hour)
        expect(instance.seconds).to eq(3600)
      end
    end

    context "using :one_day trait" do
      it "creates instance with one day expiry" do
        instance = build(:expires_after, :one_day)
        expect(instance.seconds).to eq(86_400)
      end
    end

    context "using :last_activity_anchor trait" do
      it "creates instance with last_activity anchor" do
        instance = build(:expires_after, :last_activity_anchor)
        expect(instance.anchor).to eq("last_activity")
      end
    end

    context "using :creation_anchor trait" do
      it "creates instance with creation anchor" do
        instance = build(:expires_after, :creation_anchor)
        expect(instance.anchor).to eq("creation")
      end
    end

    context "using :custom_anchor trait" do
      it "creates instance with custom anchor" do
        instance = build(:expires_after, :custom_anchor)
        expect(instance.anchor).to eq("custom_timestamp")
      end
    end

    context "overriding values" do
      it "allows custom anchor value" do
        instance = build(:expires_after, anchor: "custom")
        expect(instance.anchor).to eq("custom")
      end

      it "allows custom seconds value" do
        instance = build(:expires_after, seconds: 1200)
        expect(instance.seconds).to eq(1200)
      end

      it "allows overriding both values" do
        instance = build(:expires_after, anchor: "last_activity", seconds: 7200)
        expect(instance.anchor).to eq("last_activity")
        expect(instance.seconds).to eq(7200)
      end
    end

    context "combining traits" do
      it "allows combining anchor and expiry traits" do
        instance = build(:expires_after, :last_activity_anchor, :one_hour)
        expect(instance.anchor).to eq("last_activity")
        expect(instance.seconds).to eq(3600)
      end

      it "allows combining creation_anchor with one_day" do
        instance = build(:expires_after, :creation_anchor, :one_day)
        expect(instance.anchor).to eq("creation")
        expect(instance.seconds).to eq(86_400)
      end
    end
  end

  describe "edge cases" do
    context "when modifying attributes after initialization" do
      it "allows changing anchor" do
        instance = described_class.new(anchor: "creation", seconds: 600)
        expect(instance.anchor).to eq("creation")

        instance.anchor = "last_activity"
        expect(instance.anchor).to eq("last_activity")
      end

      it "allows changing seconds" do
        instance = described_class.new(anchor: "creation", seconds: 600)
        expect(instance.seconds).to eq(600)

        instance.seconds = 3600
        expect(instance.seconds).to eq(3600)
      end

      it "allows changing both attributes" do
        instance = described_class.new(anchor: "creation", seconds: 600)

        instance.anchor = "custom"
        instance.seconds = 1200

        expect(instance.anchor).to eq("custom")
        expect(instance.seconds).to eq(1200)
      end
    end

    context "when serializing multiple times" do
      it "produces consistent results" do
        instance = described_class.new(anchor: "creation", seconds: 600)
        first_serialization = instance.serialize
        second_serialization = instance.serialize
        expect(first_serialization).to eq(second_serialization)
      end
    end

    context "when working with unexpected data types" do
      it "accepts string seconds value" do
        instance = described_class.new(anchor: "creation", seconds: "600")
        expect(instance.seconds).to eq("600")
      end

      it "accepts symbol anchor value" do
        instance = described_class.new(anchor: :creation, seconds: 600)
        expect(instance.anchor).to eq(:creation)
      end

      it "accepts float seconds value" do
        instance = described_class.new(anchor: "creation", seconds: 600.5)
        expect(instance.seconds).to eq(600.5)
      end
    end

    context "when working with boundary values" do
      it "handles very large seconds values" do
        instance = described_class.new(anchor: "creation", seconds: 99_999_999)
        expect(instance.seconds).to eq(99_999_999)
        serialized = instance.serialize
        expect(serialized[:seconds]).to eq(99_999_999)
      end

      it "handles negative seconds values" do
        instance = described_class.new(anchor: "creation", seconds: -100)
        expect(instance.seconds).to eq(-100)
        serialized = instance.serialize
        expect(serialized[:seconds]).to eq(-100)
      end

      it "handles very long anchor strings" do
        long_anchor = "a" * 1000
        instance = described_class.new(anchor: long_anchor, seconds: 600)
        expect(instance.anchor).to eq(long_anchor)
        serialized = instance.serialize
        expect(serialized[:anchor]).to eq(long_anchor)
      end
    end

    context "when modifying after serialization" do
      it "subsequent serializations reflect modifications" do
        instance = described_class.new(anchor: "creation", seconds: 600)
        first_result = instance.serialize
        expect(first_result[:seconds]).to eq(600)

        instance.seconds = 1200
        second_result = instance.serialize
        expect(second_result[:seconds]).to eq(1200)
      end

      it "reflects anchor changes in serialization" do
        instance = described_class.new(anchor: "creation", seconds: 600)
        first_result = instance.serialize
        expect(first_result[:anchor]).to eq("creation")

        instance.anchor = "last_activity"
        second_result = instance.serialize
        expect(second_result[:anchor]).to eq("last_activity")
      end
    end
  end

  describe "common use cases" do
    context "default 10 minute expiration" do
      it "creates instance with 600 seconds" do
        instance = described_class.new(anchor: "creation", seconds: 600)
        expect(instance.seconds).to eq(600)
        expect(instance.anchor).to eq("creation")
      end
    end

    context "session expiration from creation" do
      it "uses creation anchor" do
        instance = described_class.new(anchor: "creation", seconds: 3600)
        expect(instance.anchor).to eq("creation")
        expect(instance.seconds).to eq(3600)
      end
    end

    context "session expiration from last activity" do
      it "uses last_activity anchor" do
        instance = described_class.new(anchor: "last_activity", seconds: 1800)
        expect(instance.anchor).to eq("last_activity")
        expect(instance.seconds).to eq(1800)
      end
    end

    context "various time durations" do
      it "represents 1 minute" do
        instance = described_class.new(anchor: "creation", seconds: 60)
        expect(instance.seconds).to eq(60)
      end

      it "represents 5 minutes" do
        instance = described_class.new(anchor: "creation", seconds: 300)
        expect(instance.seconds).to eq(300)
      end

      it "represents 30 minutes" do
        instance = described_class.new(anchor: "creation", seconds: 1800)
        expect(instance.seconds).to eq(1800)
      end

      it "represents 1 hour" do
        instance = described_class.new(anchor: "creation", seconds: 3600)
        expect(instance.seconds).to eq(3600)
      end

      it "represents 24 hours" do
        instance = described_class.new(anchor: "creation", seconds: 86_400)
        expect(instance.seconds).to eq(86_400)
      end
    end
  end
end

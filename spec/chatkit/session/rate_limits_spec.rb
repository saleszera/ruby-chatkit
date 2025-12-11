# frozen_string_literal: true

RSpec.describe ChatKit::Session::RateLimits do
  describe ".new" do
    context "when no arguments are provided" do
      it "initializes with default max_requests_per_1_minute value" do
        instance = described_class.new
        expect(instance.max_requests_per_1_minute).to eq(described_class::Defaults::MAX_REQUESTS_PER_1_MINUTE)
      end
    end

    context "when max_requests_per_1_minute is provided" do
      it "initializes with custom integer value" do
        instance = described_class.new(max_requests_per_1_minute: 20)
        expect(instance.max_requests_per_1_minute).to eq(20)
      end

      it "accepts zero value" do
        instance = described_class.new(max_requests_per_1_minute: 0)
        expect(instance.max_requests_per_1_minute).to eq(0)
      end

      it "accepts nil value" do
        instance = described_class.new(max_requests_per_1_minute: nil)
        expect(instance.max_requests_per_1_minute).to be_nil
      end

      it "accepts large values" do
        instance = described_class.new(max_requests_per_1_minute: 1000)
        expect(instance.max_requests_per_1_minute).to eq(1000)
      end

      it "accepts small values" do
        instance = described_class.new(max_requests_per_1_minute: 1)
        expect(instance.max_requests_per_1_minute).to eq(1)
      end
    end
  end

  describe ".build" do
    context "when no arguments are provided" do
      it "creates instance with nil max_requests_per_1_minute value" do
        instance = described_class.build
        expect(instance.max_requests_per_1_minute).to be_nil
      end
    end

    context "when max_requests_per_1_minute is provided" do
      it "creates instance with custom value" do
        instance = described_class.build(max_requests_per_1_minute: 50)
        expect(instance.max_requests_per_1_minute).to eq(50)
      end

      it "creates instance with nil value" do
        instance = described_class.build(max_requests_per_1_minute: nil)
        expect(instance.max_requests_per_1_minute).to be_nil
      end

      it "creates instance with zero value" do
        instance = described_class.build(max_requests_per_1_minute: 0)
        expect(instance.max_requests_per_1_minute).to eq(0)
      end

      it "creates instance with large value" do
        instance = described_class.build(max_requests_per_1_minute: 500)
        expect(instance.max_requests_per_1_minute).to eq(500)
      end
    end

    it "returns an instance of RateLimits" do
      instance = described_class.build
      expect(instance).to be_a(described_class)
    end
  end

  describe ".deserialize" do
    context "when data is nil" do
      it "initializes with nil max_requests_per_1_minute value" do
        instance = described_class.deserialize(nil)
        expect(instance.max_requests_per_1_minute).to be_nil
      end

      it "returns an instance of RateLimits" do
        instance = described_class.deserialize(nil)
        expect(instance).to be_a(described_class)
      end
    end

    context "when data is an empty hash" do
      it "initializes with nil max_requests_per_1_minute value" do
        instance = described_class.deserialize({})
        expect(instance.max_requests_per_1_minute).to be_nil
      end
    end

    context "when data contains max_requests_per_1_minute key" do
      it "deserializes with integer value" do
        data = { "max_requests_per_1_minute" => 30 }
        instance = described_class.deserialize(data)
        expect(instance.max_requests_per_1_minute).to eq(30)
      end

      it "deserializes with nil value" do
        data = { "max_requests_per_1_minute" => nil }
        instance = described_class.deserialize(data)
        expect(instance.max_requests_per_1_minute).to be_nil
      end

      it "deserializes with zero value" do
        data = { "max_requests_per_1_minute" => 0 }
        instance = described_class.deserialize(data)
        expect(instance.max_requests_per_1_minute).to eq(0)
      end

      it "deserializes with large value" do
        data = { "max_requests_per_1_minute" => 999 }
        instance = described_class.deserialize(data)
        expect(instance.max_requests_per_1_minute).to eq(999)
      end
    end

    context "when data contains extra keys" do
      it "extracts only max_requests_per_1_minute using dig" do
        data = {
          "max_requests_per_1_minute" => 25,
          "extra_key" => "ignored",
        }
        instance = described_class.deserialize(data)
        expect(instance.max_requests_per_1_minute).to eq(25)
      end
    end

    it "returns an instance of RateLimits" do
      instance = described_class.deserialize({ "max_requests_per_1_minute" => 15 })
      expect(instance).to be_a(described_class)
    end
  end

  describe "#serialize" do
    context "when max_requests_per_1_minute has a value" do
      it "serializes to hash with max_requests_per_1_minute key" do
        instance = described_class.new(max_requests_per_1_minute: 20)
        result = instance.serialize
        expect(result).to eq({ max_requests_per_1_minute: 20 })
      end

      it "serializes with zero value" do
        instance = described_class.new(max_requests_per_1_minute: 0)
        result = instance.serialize
        expect(result[:max_requests_per_1_minute]).to eq(0)
      end

      it "serializes with large value" do
        instance = described_class.new(max_requests_per_1_minute: 1000)
        result = instance.serialize
        expect(result[:max_requests_per_1_minute]).to eq(1000)
      end
    end

    context "when max_requests_per_1_minute is nil" do
      it "serializes to empty hash (compacts nil values)" do
        instance = described_class.new(max_requests_per_1_minute: nil)
        result = instance.serialize
        expect(result).to eq({})
      end
    end

    context "when using default value" do
      it "serializes with default max_requests_per_1_minute value" do
        instance = described_class.new
        result = instance.serialize
        expect(result).to eq({ max_requests_per_1_minute: described_class::Defaults::MAX_REQUESTS_PER_1_MINUTE })
      end
    end

    it "returns a hash" do
      instance = described_class.new(max_requests_per_1_minute: 15)
      result = instance.serialize
      expect(result).to be_a(Hash)
    end
  end

  describe "attribute accessors" do
    let(:instance) { described_class.new }

    describe "#max_requests_per_1_minute" do
      it "allows reading the max_requests_per_1_minute value" do
        expect(instance.max_requests_per_1_minute).to eq(described_class::Defaults::MAX_REQUESTS_PER_1_MINUTE)
      end

      it "allows writing integer value" do
        instance.max_requests_per_1_minute = 50
        expect(instance.max_requests_per_1_minute).to eq(50)
      end

      it "allows writing nil value" do
        instance.max_requests_per_1_minute = nil
        expect(instance.max_requests_per_1_minute).to be_nil
      end

      it "allows writing zero value" do
        instance.max_requests_per_1_minute = 0
        expect(instance.max_requests_per_1_minute).to eq(0)
      end

      it "allows writing large value" do
        instance.max_requests_per_1_minute = 999
        expect(instance.max_requests_per_1_minute).to eq(999)
      end
    end
  end

  describe "integration with FactoryBot" do
    context "using default factory" do
      it "creates valid instance" do
        instance = build(:rate_limits)
        expect(instance).to be_a(described_class)
        expect(instance.max_requests_per_1_minute).to eq(20)
      end
    end

    context "using :default_limit trait" do
      it "creates instance with default limit value" do
        instance = build(:rate_limits, :default_limit)
        expect(instance.max_requests_per_1_minute).to eq(described_class::Defaults::MAX_REQUESTS_PER_1_MINUTE)
      end
    end

    context "using :no_limit trait" do
      it "creates instance with nil max_requests_per_1_minute" do
        instance = build(:rate_limits, :no_limit)
        expect(instance.max_requests_per_1_minute).to be_nil
      end
    end

    context "using :low_limit trait" do
      it "creates instance with low limit" do
        instance = build(:rate_limits, :low_limit)
        expect(instance.max_requests_per_1_minute).to eq(5)
      end
    end

    context "using :high_limit trait" do
      it "creates instance with high limit" do
        instance = build(:rate_limits, :high_limit)
        expect(instance.max_requests_per_1_minute).to eq(100)
      end
    end

    context "using :zero_limit trait" do
      it "creates instance with zero limit" do
        instance = build(:rate_limits, :zero_limit)
        expect(instance.max_requests_per_1_minute).to eq(0)
      end
    end

    context "overriding max_requests_per_1_minute value" do
      it "allows custom value" do
        instance = build(:rate_limits, max_requests_per_1_minute: 75)
        expect(instance.max_requests_per_1_minute).to eq(75)
      end
    end
  end

  describe "round-trip serialization" do
    it "maintains data integrity when serializing and deserializing" do
      original = described_class.new(max_requests_per_1_minute: 30)
      serialized = original.serialize
      deserialized = described_class.deserialize(serialized.transform_keys(&:to_s))
      expect(deserialized.max_requests_per_1_minute).to eq(original.max_requests_per_1_minute)
    end

    it "handles nil values in round-trip" do
      original = described_class.new(max_requests_per_1_minute: nil)
      serialized = original.serialize
      deserialized = described_class.deserialize(serialized.transform_keys(&:to_s))
      expect(deserialized.max_requests_per_1_minute).to eq(original.max_requests_per_1_minute)
    end

    it "handles zero values in round-trip" do
      original = described_class.new(max_requests_per_1_minute: 0)
      serialized = original.serialize
      deserialized = described_class.deserialize(serialized.transform_keys(&:to_s))
      expect(deserialized.max_requests_per_1_minute).to eq(original.max_requests_per_1_minute)
    end
  end

  describe "edge cases" do
    context "when modifying max_requests_per_1_minute after initialization" do
      it "allows changing the value" do
        instance = described_class.new(max_requests_per_1_minute: 10)
        expect(instance.max_requests_per_1_minute).to eq(10)

        instance.max_requests_per_1_minute = 50
        expect(instance.max_requests_per_1_minute).to eq(50)

        instance.max_requests_per_1_minute = 100
        expect(instance.max_requests_per_1_minute).to eq(100)
      end

      it "allows setting to nil" do
        instance = described_class.new(max_requests_per_1_minute: 20)
        instance.max_requests_per_1_minute = nil
        expect(instance.max_requests_per_1_minute).to be_nil
      end
    end

    context "when serializing multiple times" do
      it "produces consistent results" do
        instance = described_class.new(max_requests_per_1_minute: 25)
        first_serialization = instance.serialize
        second_serialization = instance.serialize
        expect(first_serialization).to eq(second_serialization)
      end
    end

    context "when deserializing with unexpected data types" do
      it "handles string values" do
        data = { "max_requests_per_1_minute" => "20" }
        instance = described_class.deserialize(data)
        expect(instance.max_requests_per_1_minute).to eq("20")
      end

      it "handles float values" do
        data = { "max_requests_per_1_minute" => 20.5 }
        instance = described_class.deserialize(data)
        expect(instance.max_requests_per_1_minute).to eq(20.5)
      end
    end

    context "when working with boundary values" do
      it "handles very large values" do
        instance = described_class.new(max_requests_per_1_minute: 999_999)
        expect(instance.max_requests_per_1_minute).to eq(999_999)
        serialized = instance.serialize
        expect(serialized[:max_requests_per_1_minute]).to eq(999_999)
      end

      it "handles negative values" do
        instance = described_class.new(max_requests_per_1_minute: -1)
        expect(instance.max_requests_per_1_minute).to eq(-1)
        serialized = instance.serialize
        expect(serialized[:max_requests_per_1_minute]).to eq(-1)
      end

      it "handles single request limit" do
        instance = described_class.new(max_requests_per_1_minute: 1)
        expect(instance.max_requests_per_1_minute).to eq(1)
        serialized = instance.serialize
        expect(serialized[:max_requests_per_1_minute]).to eq(1)
      end
    end

    context "when modifying after serialization" do
      it "subsequent serializations reflect modifications" do
        instance = described_class.new(max_requests_per_1_minute: 15)
        first_result = instance.serialize
        expect(first_result[:max_requests_per_1_minute]).to eq(15)

        instance.max_requests_per_1_minute = 30
        second_result = instance.serialize
        expect(second_result[:max_requests_per_1_minute]).to eq(30)
      end

      it "handles transition to nil" do
        instance = described_class.new(max_requests_per_1_minute: 20)
        first_result = instance.serialize
        expect(first_result).to have_key(:max_requests_per_1_minute)

        instance.max_requests_per_1_minute = nil
        second_result = instance.serialize
        expect(second_result).not_to have_key(:max_requests_per_1_minute)
      end
    end
  end

  describe "constants and defaults" do
    it "has correct MAX_REQUESTS_PER_1_MINUTE default" do
      expect(described_class::Defaults::MAX_REQUESTS_PER_1_MINUTE).to eq(10)
    end

    it "uses Defaults::MAX_REQUESTS_PER_1_MINUTE as default value" do
      instance = described_class.new
      expect(instance.max_requests_per_1_minute).to eq(described_class::Defaults::MAX_REQUESTS_PER_1_MINUTE)
    end
  end

  describe "documentation compliance" do
    context "according to the class documentation" do
      it "defaults to 10 requests per minute when omitted" do
        instance = described_class.new
        expect(instance.max_requests_per_1_minute).to eq(10)
      end
    end
  end

  describe "common use cases" do
    context "rate limiting scenarios" do
      it "represents no rate limiting (nil)" do
        instance = described_class.new(max_requests_per_1_minute: nil)
        expect(instance.max_requests_per_1_minute).to be_nil
      end

      it "represents very restrictive rate limiting" do
        instance = described_class.new(max_requests_per_1_minute: 1)
        expect(instance.max_requests_per_1_minute).to eq(1)
      end

      it "represents conservative rate limiting" do
        instance = described_class.new(max_requests_per_1_minute: 5)
        expect(instance.max_requests_per_1_minute).to eq(5)
      end

      it "represents default rate limiting" do
        instance = described_class.new(max_requests_per_1_minute: 10)
        expect(instance.max_requests_per_1_minute).to eq(10)
      end

      it "represents moderate rate limiting" do
        instance = described_class.new(max_requests_per_1_minute: 20)
        expect(instance.max_requests_per_1_minute).to eq(20)
      end

      it "represents generous rate limiting" do
        instance = described_class.new(max_requests_per_1_minute: 100)
        expect(instance.max_requests_per_1_minute).to eq(100)
      end

      it "represents high throughput rate limiting" do
        instance = described_class.new(max_requests_per_1_minute: 1000)
        expect(instance.max_requests_per_1_minute).to eq(1000)
      end
    end
  end
end

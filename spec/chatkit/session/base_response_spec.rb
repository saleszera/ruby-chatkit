# frozen_string_literal: true

RSpec.describe ChatKit::Session::BaseResponse do
  describe ".new" do
    let(:chatkit_configuration) { build(:chatkit_configuration) }
    let(:rate_limits) { build(:rate_limits) }
    let(:workflow) { build(:workflow) }

    context "when all required arguments are provided" do
      it "initializes with all attributes" do
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret_abc",
          expires_at: "1234567890",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: { "id" => "user_1" },
          workflow:
        )

        expect(instance.id).to eq("sess_123")
        expect(instance.object).to eq("chatkit.session")
        expect(instance.status).to eq("active")
        expect(instance.chatkit_configuration).to eq(chatkit_configuration)
        expect(instance.client_secret).to eq("secret_abc")
        expect(instance.expires_at).to eq("1234567890")
        expect(instance.max_requests_per_1_minute).to eq(10)
        expect(instance.rate_limits).to eq(rate_limits)
        expect(instance.user).to eq({ "id" => "user_1" })
        expect(instance.workflow).to eq(workflow)
      end
    end

    context "when any required argument is missing" do
      it "raises ArgumentError" do
        expect do
          described_class.new(
            id: "sess_123",
            object: "chatkit.session",
            status: "active"
          )
        end.to raise_error(ArgumentError)
      end
    end

    context "with different status values" do
      it "accepts active status" do
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )
        expect(instance.status).to eq("active")
      end

      it "accepts expired status" do
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "expired",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )
        expect(instance.status).to eq("expired")
      end
    end

    context "with different user values" do
      it "accepts hash with user data" do
        user_data = { "id" => "user_123", "name" => "John" }
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: user_data,
          workflow:
        )
        expect(instance.user).to eq(user_data)
      end

      it "accepts empty hash" do
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )
        expect(instance.user).to eq({})
      end

      it "accepts nil value" do
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: nil,
          workflow:
        )
        expect(instance.user).to be_nil
      end
    end

    context "with different max_requests_per_1_minute values" do
      it "accepts integer value" do
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 50,
          rate_limits:,
          user: {},
          workflow:
        )
        expect(instance.max_requests_per_1_minute).to eq(50)
      end

      it "accepts nil value" do
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: nil,
          rate_limits:,
          user: {},
          workflow:
        )
        expect(instance.max_requests_per_1_minute).to be_nil
      end
    end
  end

  describe ".deserialize" do
    context "when data is nil" do
      it "initializes with nil values" do
        instance = described_class.deserialize(nil)
        expect(instance.id).to be_nil
        expect(instance.object).to be_nil
        expect(instance.status).to be_nil
        expect(instance.client_secret).to be_nil
        expect(instance.expires_at).to be_nil
        expect(instance.max_requests_per_1_minute).to be_nil
        expect(instance.user).to be_nil
      end

      it "creates nested objects from nil" do
        instance = described_class.deserialize(nil)
        expect(instance.chatkit_configuration).to be_a(ChatKit::Session::ChatKitConfiguration)
        expect(instance.rate_limits).to be_a(ChatKit::Session::RateLimits)
        expect(instance.workflow).to be_a(ChatKit::Session::Workflow)
      end

      it "returns an instance of Response" do
        instance = described_class.deserialize(nil)
        expect(instance).to be_a(described_class)
      end
    end

    context "when data is an empty hash" do
      it "initializes with nil values" do
        instance = described_class.deserialize({})
        expect(instance.id).to be_nil
        expect(instance.object).to be_nil
        expect(instance.status).to be_nil
      end
    end

    context "when data contains all keys" do
      it "deserializes complete response data" do
        data = {
          "id" => "sess_456",
          "object" => "chatkit.session",
          "status" => "active",
          "chatkit_configuration" => { "history" => { "enabled" => true } },
          "client_secret" => "secret_def",
          "expires_at" => "9876543210",
          "max_requests_per_1_minute" => 20,
          "rate_limits" => { "max_requests_per_1_minute" => 15 },
          "user" => { "id" => "user_456", "email" => "test@example.com" },
          "workflow" => { "id" => "wf_123", "version" => "1.0.0" },
        }
        instance = described_class.deserialize(data)

        expect(instance.id).to eq("sess_456")
        expect(instance.object).to eq("chatkit.session")
        expect(instance.status).to eq("active")
        expect(instance.chatkit_configuration).to be_a(ChatKit::Session::ChatKitConfiguration)
        expect(instance.client_secret).to eq("secret_def")
        expect(instance.expires_at).to eq("9876543210")
        expect(instance.max_requests_per_1_minute).to eq(20)
        expect(instance.rate_limits).to be_a(ChatKit::Session::RateLimits)
        expect(instance.user).to eq({ "id" => "user_456", "email" => "test@example.com" })
        expect(instance.workflow).to be_a(ChatKit::Session::Workflow)
      end

      it "deserializes nested chatkit_configuration" do
        data = {
          "id" => "sess_123",
          "chatkit_configuration" => {
            "history" => { "enabled" => true },
            "file_upload" => { "enabled" => false },
          },
        }
        instance = described_class.deserialize(data)
        expect(instance.chatkit_configuration).to be_a(ChatKit::Session::ChatKitConfiguration)
      end

      it "deserializes nested rate_limits" do
        data = {
          "id" => "sess_123",
          "rate_limits" => { "max_requests_per_1_minute" => 25 },
        }
        instance = described_class.deserialize(data)
        expect(instance.rate_limits).to be_a(ChatKit::Session::RateLimits)
        expect(instance.rate_limits.max_requests_per_1_minute).to eq(25)
      end

      it "deserializes nested workflow" do
        data = {
          "id" => "sess_123",
          "workflow" => {
            "id" => "wf_789",
            "state_variables" => { "var" => "value" },
          },
        }
        instance = described_class.deserialize(data)
        expect(instance.workflow).to be_a(ChatKit::Session::Workflow)
        expect(instance.workflow.id).to eq("wf_789")
      end

      it "deserializes with nil user" do
        data = {
          "id" => "sess_123",
          "user" => nil,
        }
        instance = described_class.deserialize(data)
        expect(instance.user).to be_nil
      end

      it "deserializes with empty user hash" do
        data = {
          "id" => "sess_123",
          "user" => {},
        }
        instance = described_class.deserialize(data)
        expect(instance.user).to eq({})
      end

      it "deserializes with complex user data" do
        data = {
          "id" => "sess_123",
          "user" => {
            "id" => "user_123",
            "name" => "Jane Doe",
            "metadata" => { "role" => "admin" },
          },
        }
        instance = described_class.deserialize(data)
        expect(instance.user).to eq(data["user"])
      end
    end

    context "when data contains extra keys" do
      it "extracts only known keys using dig" do
        data = {
          "id" => "sess_extra",
          "object" => "chatkit.session",
          "status" => "active",
          "extra_key" => "ignored",
          "another_extra" => "also_ignored",
        }
        instance = described_class.deserialize(data)
        expect(instance.id).to eq("sess_extra")
        expect(instance.object).to eq("chatkit.session")
        expect(instance.status).to eq("active")
      end
    end

    it "returns an instance of Response" do
      instance = described_class.deserialize({ "id" => "sess_test" })
      expect(instance).to be_a(described_class)
    end
  end

  describe "#serialize" do
    let(:chatkit_configuration) { build(:chatkit_configuration) }
    let(:rate_limits) { build(:rate_limits) }
    let(:workflow) { build(:workflow) }

    context "when all attributes have values" do
      it "serializes to complete hash" do
        instance = described_class.new(
          id: "sess_serialize_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret_serialize",
          expires_at: "1111111111",
          max_requests_per_1_minute: 30,
          rate_limits:,
          user: { "id" => "user_serialize" },
          workflow:
        )
        result = instance.serialize

        expect(result[:id]).to eq("sess_serialize_123")
        expect(result[:object]).to eq("chatkit.session")
        expect(result[:status]).to eq("active")
        expect(result[:chatkit_configuration]).to be_a(Hash)
        expect(result[:client_secret]).to eq("secret_serialize")
        expect(result[:expires_at]).to eq("1111111111")
        expect(result[:max_requests_per_1_minute]).to eq(30)
        expect(result[:rate_limits]).to be_a(Hash)
        expect(result[:user]).to eq({ "id" => "user_serialize" })
        expect(result[:workflow]).to be_a(Hash)
      end

      it "calls serialize on chatkit_configuration object" do
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )
        result = instance.serialize
        expect(result[:chatkit_configuration]).to eq(chatkit_configuration.serialize)
      end

      it "calls serialize on rate_limits object" do
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )
        result = instance.serialize
        expect(result[:rate_limits]).to eq(rate_limits.serialize)
      end

      it "calls serialize on workflow object" do
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )
        result = instance.serialize
        expect(result[:workflow]).to eq(workflow.serialize)
      end
    end

    context "when some attributes are nil" do
      it "includes nil values (does not compact)" do
        instance = described_class.new(
          id: "sess_nil",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: nil,
          expires_at: nil,
          max_requests_per_1_minute: nil,
          rate_limits:,
          user: nil,
          workflow:
        )
        result = instance.serialize

        expect(result[:id]).to eq("sess_nil")
        expect(result[:client_secret]).to be_nil
        expect(result[:expires_at]).to be_nil
        expect(result[:max_requests_per_1_minute]).to be_nil
        expect(result[:user]).to be_nil
      end
    end

    context "when user is empty hash" do
      it "includes empty hash in serialization" do
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )
        result = instance.serialize
        expect(result[:user]).to eq({})
      end
    end

    context "when user has complex structure" do
      it "serializes complex user data" do
        user_data = {
          "id" => "user_123",
          "profile" => { "name" => "John", "age" => 30 },
          "permissions" => %w[read write],
        }
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: user_data,
          workflow:
        )
        result = instance.serialize
        expect(result[:user]).to eq(user_data)
      end
    end

    it "returns a hash" do
      instance = described_class.new(
        id: "sess_test",
        object: "chatkit.session",
        status: "active",
        chatkit_configuration:,
        client_secret: "secret",
        expires_at: "123",
        max_requests_per_1_minute: 10,
        rate_limits:,
        user: {},
        workflow:
      )
      result = instance.serialize
      expect(result).to be_a(Hash)
    end
  end

  describe "attribute accessors" do
    let(:chatkit_configuration) { build(:chatkit_configuration) }
    let(:rate_limits) { build(:rate_limits) }
    let(:workflow) { build(:workflow) }
    let(:instance) do
      described_class.new(
        id: "sess_accessor",
        object: "chatkit.session",
        status: "active",
        chatkit_configuration:,
        client_secret: "secret",
        expires_at: "123",
        max_requests_per_1_minute: 10,
        rate_limits:,
        user: {},
        workflow:
      )
    end

    describe "#id" do
      it "allows reading the id value" do
        expect(instance.id).to eq("sess_accessor")
      end

      it "allows writing new id value" do
        instance.id = "sess_new"
        expect(instance.id).to eq("sess_new")
      end
    end

    describe "#object" do
      it "allows reading the object value" do
        expect(instance.object).to eq("chatkit.session")
      end

      it "allows writing new object value" do
        instance.object = "new.object"
        expect(instance.object).to eq("new.object")
      end
    end

    describe "#status" do
      it "allows reading the status value" do
        expect(instance.status).to eq("active")
      end

      it "allows writing new status value" do
        instance.status = "expired"
        expect(instance.status).to eq("expired")
      end
    end

    describe "#chatkit_configuration" do
      it "allows reading the chatkit_configuration value" do
        expect(instance.chatkit_configuration).to eq(chatkit_configuration)
      end

      it "allows writing new chatkit_configuration value" do
        new_config = build(:chatkit_configuration)
        instance.chatkit_configuration = new_config
        expect(instance.chatkit_configuration).to eq(new_config)
      end
    end

    describe "#client_secret" do
      it "allows reading the client_secret value" do
        expect(instance.client_secret).to eq("secret")
      end

      it "allows writing new client_secret value" do
        instance.client_secret = "new_secret"
        expect(instance.client_secret).to eq("new_secret")
      end
    end

    describe "#expires_at" do
      it "allows reading the expires_at value" do
        expect(instance.expires_at).to eq("123")
      end

      it "allows writing new expires_at value" do
        instance.expires_at = "456"
        expect(instance.expires_at).to eq("456")
      end
    end

    describe "#max_requests_per_1_minute" do
      it "allows reading the max_requests_per_1_minute value" do
        expect(instance.max_requests_per_1_minute).to eq(10)
      end

      it "allows writing new max_requests_per_1_minute value" do
        instance.max_requests_per_1_minute = 50
        expect(instance.max_requests_per_1_minute).to eq(50)
      end
    end

    describe "#rate_limits" do
      it "allows reading the rate_limits value" do
        expect(instance.rate_limits).to eq(rate_limits)
      end

      it "allows writing new rate_limits value" do
        new_limits = build(:rate_limits, max_requests_per_1_minute: 100)
        instance.rate_limits = new_limits
        expect(instance.rate_limits).to eq(new_limits)
      end
    end

    describe "#user" do
      it "allows reading the user value" do
        expect(instance.user).to eq({})
      end

      it "allows writing new user value" do
        new_user = { "id" => "user_new" }
        instance.user = new_user
        expect(instance.user).to eq(new_user)
      end
    end

    describe "#workflow" do
      it "allows reading the workflow value" do
        expect(instance.workflow).to eq(workflow)
      end

      it "allows writing new workflow value" do
        new_workflow = build(:workflow, id: "wf_new")
        instance.workflow = new_workflow
        expect(instance.workflow).to eq(new_workflow)
      end
    end
  end

  describe "integration with FactoryBot" do
    context "using default factory" do
      it "creates valid instance" do
        instance = build(:base_response)
        expect(instance).to be_a(described_class)
        expect(instance.id).to eq("sess_abc123")
        expect(instance.object).to eq("chatkit.session")
        expect(instance.status).to eq("active")
        expect(instance.chatkit_configuration).to be_a(ChatKit::Session::ChatKitConfiguration)
        expect(instance.client_secret).to eq("secret_xyz789")
        expect(instance.rate_limits).to be_a(ChatKit::Session::RateLimits)
        expect(instance.workflow).to be_a(ChatKit::Session::Workflow)
      end
    end

    context "using :expired trait" do
      it "creates instance with expired status" do
        instance = build(:base_response, :expired)
        expect(instance.status).to eq("expired")
      end
    end

    context "using :with_nil_user trait" do
      it "creates instance with nil user" do
        instance = build(:base_response, :with_nil_user)
        expect(instance.user).to be_nil
      end
    end

    context "using :with_empty_user trait" do
      it "creates instance with empty user hash" do
        instance = build(:base_response, :with_empty_user)
        expect(instance.user).to eq({})
      end
    end

    context "using :high_rate_limit trait" do
      it "creates instance with high rate limit" do
        instance = build(:base_response, :high_rate_limit)
        expect(instance.max_requests_per_1_minute).to eq(100)
      end
    end

    context "using :low_rate_limit trait" do
      it "creates instance with low rate limit" do
        instance = build(:base_response, :low_rate_limit)
        expect(instance.max_requests_per_1_minute).to eq(1)
      end
    end

    context "overriding attributes" do
      it "allows custom id" do
        instance = build(:base_response, id: "sess_custom")
        expect(instance.id).to eq("sess_custom")
      end

      it "allows custom status" do
        instance = build(:base_response, status: "pending")
        expect(instance.status).to eq("pending")
      end

      it "allows custom user" do
        instance = build(:base_response, user: { "id" => "custom_user" })
        expect(instance.user).to eq({ "id" => "custom_user" })
      end
    end
  end

  describe "round-trip serialization" do
    let(:chatkit_configuration) { build(:chatkit_configuration) }
    let(:rate_limits) { build(:rate_limits) }
    let(:workflow) { build(:workflow) }

    it "maintains data integrity with all attributes" do
      original = described_class.new(
        id: "sess_roundtrip",
        object: "chatkit.session",
        status: "active",
        chatkit_configuration:,
        client_secret: "secret_roundtrip",
        expires_at: "2222222222",
        max_requests_per_1_minute: 40,
        rate_limits:,
        user: { "id" => "user_rt", "name" => "Test" },
        workflow:
      )
      serialized = original.serialize
      deserialized = described_class.deserialize(JSON.parse(serialized.to_json))

      expect(deserialized.id).to eq(original.id)
      expect(deserialized.object).to eq(original.object)
      expect(deserialized.status).to eq(original.status)
      expect(deserialized.client_secret).to eq(original.client_secret)
      expect(deserialized.expires_at).to eq(original.expires_at)
      expect(deserialized.max_requests_per_1_minute).to eq(original.max_requests_per_1_minute)
      expect(deserialized.user).to eq(original.user)
    end

    it "maintains chatkit_configuration data integrity" do
      original = described_class.new(
        id: "sess_config",
        object: "chatkit.session",
        status: "active",
        chatkit_configuration:,
        client_secret: "secret",
        expires_at: "123",
        max_requests_per_1_minute: 10,
        rate_limits:,
        user: {},
        workflow:
      )
      serialized = original.serialize
      deserialized = described_class.deserialize(JSON.parse(serialized.to_json))

      expect(deserialized.chatkit_configuration).to be_a(ChatKit::Session::ChatKitConfiguration)
    end

    it "maintains rate_limits data integrity" do
      original = described_class.new(
        id: "sess_limits",
        object: "chatkit.session",
        status: "active",
        chatkit_configuration:,
        client_secret: "secret",
        expires_at: "123",
        max_requests_per_1_minute: 10,
        rate_limits:,
        user: {},
        workflow:
      )
      serialized = original.serialize
      deserialized = described_class.deserialize(JSON.parse(serialized.to_json))

      expect(deserialized.rate_limits).to be_a(ChatKit::Session::RateLimits)
    end

    it "maintains workflow data integrity" do
      original = described_class.new(
        id: "sess_wf",
        object: "chatkit.session",
        status: "active",
        chatkit_configuration:,
        client_secret: "secret",
        expires_at: "123",
        max_requests_per_1_minute: 10,
        rate_limits:,
        user: {},
        workflow:
      )
      serialized = original.serialize
      deserialized = described_class.deserialize(JSON.parse(serialized.to_json))

      expect(deserialized.workflow).to be_a(ChatKit::Session::Workflow)
      expect(deserialized.workflow.id).to eq(workflow.id)
    end

    it "maintains data integrity with nil user" do
      original = described_class.new(
        id: "sess_nil_user",
        object: "chatkit.session",
        status: "active",
        chatkit_configuration:,
        client_secret: "secret",
        expires_at: "123",
        max_requests_per_1_minute: 10,
        rate_limits:,
        user: nil,
        workflow:
      )
      serialized = original.serialize
      deserialized = described_class.deserialize(JSON.parse(serialized.to_json))

      expect(deserialized.user).to be_nil
    end

    it "maintains data integrity with complex user" do
      complex_user = {
        "id" => "user_complex",
        "metadata" => { "role" => "admin", "department" => "IT" },
        "tags" => %w[vip beta_tester],
      }
      original = described_class.new(
        id: "sess_complex",
        object: "chatkit.session",
        status: "active",
        chatkit_configuration:,
        client_secret: "secret",
        expires_at: "123",
        max_requests_per_1_minute: 10,
        rate_limits:,
        user: complex_user,
        workflow:
      )
      serialized = original.serialize
      deserialized = described_class.deserialize(JSON.parse(serialized.to_json))

      expect(deserialized.user).to eq(complex_user)
    end
  end

  describe "edge cases" do
    let(:chatkit_configuration) { build(:chatkit_configuration) }
    let(:rate_limits) { build(:rate_limits) }
    let(:workflow) { build(:workflow) }

    context "when modifying attributes after initialization" do
      it "allows changing all attributes" do
        instance = described_class.new(
          id: "sess_original",
          object: "original.object",
          status: "active",
          chatkit_configuration:,
          client_secret: "original_secret",
          expires_at: "111",
          max_requests_per_1_minute: 5,
          rate_limits:,
          user: { "id" => "original_user" },
          workflow:
        )

        instance.id = "sess_modified"
        instance.object = "modified.object"
        instance.status = "expired"
        instance.client_secret = "modified_secret"
        instance.expires_at = "999"
        instance.max_requests_per_1_minute = 100
        instance.user = { "id" => "modified_user" }

        expect(instance.id).to eq("sess_modified")
        expect(instance.object).to eq("modified.object")
        expect(instance.status).to eq("expired")
        expect(instance.client_secret).to eq("modified_secret")
        expect(instance.expires_at).to eq("999")
        expect(instance.max_requests_per_1_minute).to eq(100)
        expect(instance.user).to eq({ "id" => "modified_user" })
      end
    end

    context "when serializing multiple times" do
      it "produces consistent results" do
        instance = described_class.new(
          id: "sess_consistent",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )
        first_serialization = instance.serialize
        second_serialization = instance.serialize

        expect(first_serialization).to eq(second_serialization)
      end
    end

    context "when modifying after serialization" do
      it "subsequent serializations reflect modifications" do
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret1",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )
        first_result = instance.serialize
        expect(first_result[:client_secret]).to eq("secret1")

        instance.client_secret = "secret2"
        second_result = instance.serialize
        expect(second_result[:client_secret]).to eq("secret2")
      end
    end

    context "when deserializing with unexpected data types" do
      it "handles numeric id" do
        data = { "id" => 12_345 }
        instance = described_class.deserialize(data)
        expect(instance.id).to eq(12_345)
      end

      it "handles numeric max_requests_per_1_minute as string" do
        data = { "max_requests_per_1_minute" => "50" }
        instance = described_class.deserialize(data)
        expect(instance.max_requests_per_1_minute).to eq("50")
      end

      it "handles string user instead of hash" do
        data = { "user" => "string_value" }
        instance = described_class.deserialize(data)
        expect(instance.user).to eq("string_value")
      end
    end

    context "when working with timestamps" do
      it "handles future expiration time" do
        future_time = (Time.now + 7200).to_i.to_s
        instance = described_class.new(
          id: "sess_future",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: future_time,
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )
        expect(instance.expires_at).to eq(future_time)
      end

      it "handles past expiration time" do
        past_time = (Time.now - 7200).to_i.to_s
        instance = described_class.new(
          id: "sess_past",
          object: "chatkit.session",
          status: "expired",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: past_time,
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )
        expect(instance.expires_at).to eq(past_time)
      end
    end

    context "when working with nested objects" do
      it "can replace chatkit_configuration" do
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )

        new_config = build(:chatkit_configuration, :with_objects)
        instance.chatkit_configuration = new_config
        expect(instance.chatkit_configuration).to eq(new_config)
      end

      it "can replace rate_limits" do
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )

        new_limits = build(:rate_limits, :high_limit)
        instance.rate_limits = new_limits
        expect(instance.rate_limits).to eq(new_limits)
      end

      it "can replace workflow" do
        instance = described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )

        new_workflow = build(:workflow, :minimal)
        instance.workflow = new_workflow
        expect(instance.workflow).to eq(new_workflow)
      end
    end
  end

  describe "required parameters validation" do
    let(:chatkit_configuration) { build(:chatkit_configuration) }
    let(:rate_limits) { build(:rate_limits) }
    let(:workflow) { build(:workflow) }

    it "requires id parameter" do
      expect do
        described_class.new(
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )
      end.to raise_error(ArgumentError)
    end

    it "requires object parameter" do
      expect do
        described_class.new(
          id: "sess_123",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )
      end.to raise_error(ArgumentError)
    end

    it "requires status parameter" do
      expect do
        described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          chatkit_configuration:,
          client_secret: "secret",
          expires_at: "123",
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: {},
          workflow:
        )
      end.to raise_error(ArgumentError)
    end

    it "requires all 10 parameters" do
      expect do
        described_class.new(
          id: "sess_123",
          object: "chatkit.session",
          status: "active"
        )
      end.to raise_error(ArgumentError)
    end
  end

  describe "common use cases" do
    let(:chatkit_configuration) { build(:chatkit_configuration) }
    let(:rate_limits) { build(:rate_limits) }
    let(:workflow) { build(:workflow) }

    context "session creation scenarios" do
      it "creates active session with user data" do
        session = described_class.new(
          id: "sess_user_123",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret_abc",
          expires_at: (Time.now + 3600).to_i.to_s,
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: { "id" => "user_123", "email" => "user@example.com" },
          workflow:
        )

        expect(session.status).to eq("active")
        expect(session.user).to include("id", "email")
      end

      it "creates expired session" do
        session = described_class.new(
          id: "sess_expired",
          object: "chatkit.session",
          status: "expired",
          chatkit_configuration:,
          client_secret: "secret_old",
          expires_at: (Time.now - 3600).to_i.to_s,
          max_requests_per_1_minute: 10,
          rate_limits:,
          user: nil,
          workflow:
        )

        expect(session.status).to eq("expired")
      end

      it "creates session with high rate limits" do
        session = described_class.new(
          id: "sess_premium",
          object: "chatkit.session",
          status: "active",
          chatkit_configuration:,
          client_secret: "secret_premium",
          expires_at: (Time.now + 7200).to_i.to_s,
          max_requests_per_1_minute: 100,
          rate_limits: build(:rate_limits, :high_limit),
          user: { "id" => "premium_user", "tier" => "premium" },
          workflow:
        )

        expect(session.max_requests_per_1_minute).to eq(100)
      end
    end
  end
end

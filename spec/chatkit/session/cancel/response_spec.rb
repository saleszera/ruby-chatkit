# frozen_string_literal: true

require "spec_helper"

RSpec.describe ChatKit::Session::Cancel::Response do
  describe ".deserialize" do
    subject(:response) { described_class.deserialize(data) }

    let(:data) do
      {
        "id" => "sess_123",
        "object" => "session",
        "status" => "cancelled",
        "client_secret" => "secret",
        "expires_at" => "2025-12-11T00:00:00Z",
        "max_requests_per_1_minute" => 10,
        "user" => "user_1",
        "ttl_seconds" => 3600,
        "cancelled_at" => "2025-12-10T00:00:00Z",
        "chatkit_configuration" => { "some_key" => "value" },
        "rate_limits" => { "max_requests_per_1_minute" => 10 },
        "scope" => { "customer_id" => "cust_1" },
        "workflow" => { "id" => "wf_1", "version" => "v1" },
      }
    end

    it "returns a Response instance" do
      expect(response).to be_a(described_class)
    end

    it "sets scalar attributes from the input hash" do
      expect(response.id).to eq("sess_123")
      expect(response.object).to eq("session")
      expect(response.status).to eq("cancelled")
      expect(response.client_secret).to eq("secret")
      expect(response.expires_at).to eq("2025-12-11T00:00:00Z")
      expect(response.max_requests_per_1_minute).to eq(10)
      expect(response.user).to eq("user_1")
      expect(response.ttl_seconds).to eq(3600)
      expect(response.cancelled_at).to eq("2025-12-10T00:00:00Z")
    end

    it "deserializes nested objects" do
      expect(response.chatkit_configuration).to be_a(ChatKit::Session::ChatKitConfiguration)
      expect(response.rate_limits).to be_a(ChatKit::Session::RateLimits)
      expect(response.scope).to be_a(ChatKit::Session::Cancel::Scope)
      expect(response.workflow).to be_a(ChatKit::Session::Workflow)
    end

    context "when data is nil" do
      subject(:response_nil) { described_class.deserialize(nil) }

      it "returns a Response instance with nil scalars and default nested objects" do
        expect(response_nil).to be_a(described_class)
        expect(response_nil.id).to be_nil
        expect(response_nil.object).to be_nil
        expect(response_nil.status).to be_nil
        expect(response_nil.client_secret).to be_nil
        expect(response_nil.expires_at).to be_nil
        expect(response_nil.max_requests_per_1_minute).to be_nil
        expect(response_nil.user).to be_nil
        expect(response_nil.ttl_seconds).to be_nil
        expect(response_nil.cancelled_at).to be_nil

        expect(response_nil.chatkit_configuration).to be_a(ChatKit::Session::ChatKitConfiguration)
        expect(response_nil.rate_limits).to be_a(ChatKit::Session::RateLimits)
        expect(response_nil.scope).to be_a(ChatKit::Session::Cancel::Scope)
        expect(response_nil.workflow).to be_a(ChatKit::Session::Workflow)
      end
    end
  end
end

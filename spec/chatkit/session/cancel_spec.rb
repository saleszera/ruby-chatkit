# frozen_string_literal: true

RSpec.describe ChatKit::Session::Cancel do
  let(:api_key) { "test_api_key_123" }
  let(:host) { "https://api.openai.com" }
  let(:session_id) { "cksess_123" }
  let(:client) { ChatKit::Client.new(api_key:, host:) }

  before do
    # Configure ChatKit with API key
    ChatKit.configure do |config|
      config.api_key = api_key
      config.host = host
    end
  end

  describe ".new" do
    context "when all required arguments are provided" do
      it "initializes with session_id" do
        instance = described_class.new(session_id:, client:)

        expect(instance.instance_variable_get(:@session_id)).to eq(session_id)
        expect(instance.instance_variable_get(:@client)).to eq(client)
      end
    end

    context "when client is not provided" do
      it "initializes with default client" do
        instance = described_class.new(session_id:)

        expect(instance.instance_variable_get(:@session_id)).to eq(session_id)
        expect(instance.instance_variable_get(:@client)).to be_a(ChatKit::Client)
      end
    end
  end

  describe ".call" do
    it "creates a new instance and calls #call" do
      success_response = load_fixture("success.json", subdir: "session/cancel")

      stub_request(:post, "#{host}/v1/chatkit/sessions/#{session_id}/cancel")
        .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })

      expect(described_class).to receive(:new).with(session_id:, client:).and_call_original

      result = described_class.call(session_id:, client:)
      expect(result).to be_a(ChatKit::Session::Cancel::Response)
    end
  end

  describe "#call" do
    context "when API returns success response (200)" do
      let(:success_response) { load_fixture("success.json", subdir: "session/cancel") }

      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions/#{session_id}/cancel")
          .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })
      end

      it "returns a Response object" do
        instance = described_class.new(session_id:, client:)
        result = instance.call

        expect(result).to be_a(ChatKit::Session::Cancel::Response)
      end

      it "correctly deserializes the response" do
        instance = described_class.new(session_id:, client:)
        result = instance.call

        expect(result.id).to eq("cksess_123")
        expect(result.object).to eq("chatkit.session")
        expect(result.status).to eq("cancelled")
        expect(result.user).to eq("123")
        expect(result.expires_at).to eq(1_765_453_320)
        expect(result.max_requests_per_1_minute).to eq(10)
      end

      it "includes chatkit_configuration" do
        instance = described_class.new(session_id:, client:)
        result = instance.call

        expect(result.chatkit_configuration).to be_a(ChatKit::Session::ChatKitConfiguration)
        expect(result.chatkit_configuration.automatic_thread_titling.enabled).to be true
        expect(result.chatkit_configuration.file_upload.enabled).to be false
        expect(result.chatkit_configuration.file_upload.max_file_size).to eq(512)
        expect(result.chatkit_configuration.file_upload.max_files).to eq(10)
        expect(result.chatkit_configuration.history.enabled).to be true
      end

      it "includes rate_limits" do
        instance = described_class.new(session_id:, client:)
        result = instance.call

        expect(result.rate_limits).to be_a(ChatKit::Session::RateLimits)
        expect(result.rate_limits.max_requests_per_1_minute).to eq(10)
      end

      it "includes workflow information" do
        instance = described_class.new(session_id:, client:)
        result = instance.call

        expect(result.workflow).to be_a(ChatKit::Session::Workflow)
        expect(result.workflow.id).to eq("wf_123")
        expect(result.workflow.tracing.enabled).to be true
      end

      it "sends correct headers" do
        request_stub = stub_request(:post, "#{host}/v1/chatkit/sessions/#{session_id}/cancel")
          .with(
            headers: {
              "Authorization" => "Bearer #{api_key}",
              "Accept" => "application/json",
              "Content-Type" => "application/json",
              "OpenAI-Beta" => "chatkit_beta=v1",
            }
          )
          .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })

        instance = described_class.new(session_id:, client:)
        instance.call

        expect(request_stub).to have_been_requested
      end

      it "makes POST request to correct endpoint" do
        request_stub = stub_request(:post, "#{host}/v1/chatkit/sessions/#{session_id}/cancel")
          .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })

        instance = described_class.new(session_id:, client:)
        instance.call

        expect(request_stub).to have_been_requested.once
      end
    end

    context "when API returns 401 unauthorized error" do
      let(:unauthorized_response) { load_fixture("unauthorized.json", subdir: "session/cancel") }

      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions/#{session_id}/cancel")
          .to_return(status: 401, body: unauthorized_response, headers: { "Content-Type" => "application/json" })
      end

      it "raises CancelError" do
        instance = described_class.new(session_id:, client:)

        expect { instance.call }.to raise_error(
          ChatKit::Session::Cancel::CancelError,
          "Failed to cancel session: 401 Unauthorized"
        )
      end
    end

    context "when API returns 400 with invalid session_id" do
      let(:invalid_session_id_response) { load_fixture("invalid_session_id.json", subdir: "session/cancel") }
      let(:invalid_session_id) { "id" }

      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions/#{invalid_session_id}/cancel")
          .to_return(status: 400, body: invalid_session_id_response, headers: { "Content-Type" => "application/json" })
      end

      it "raises CancelError" do
        instance = described_class.new(session_id: invalid_session_id, client:)

        expect { instance.call }.to raise_error(
          ChatKit::Session::Cancel::CancelError,
          "Failed to cancel session: 400 Bad Request"
        )
      end

      it "includes the invalid session_id in the request" do
        request_stub = stub_request(:post, "#{host}/v1/chatkit/sessions/#{invalid_session_id}/cancel")
          .to_return(status: 400, body: invalid_session_id_response, headers: { "Content-Type" => "application/json" })

        instance = described_class.new(session_id: invalid_session_id, client:)

        expect { instance.call }.to raise_error(ChatKit::Session::Cancel::CancelError)
        expect(request_stub).to have_been_requested
      end
    end

    context "when API returns 400 with missing header" do
      let(:missing_header_response) { load_fixture("missing_header.json", subdir: "session/cancel") }

      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions/#{session_id}/cancel")
          .to_return(status: 400, body: missing_header_response, headers: { "Content-Type" => "application/json" })
      end

      it "raises CancelError" do
        instance = described_class.new(session_id:, client:)

        expect { instance.call }.to raise_error(
          ChatKit::Session::Cancel::CancelError,
          "Failed to cancel session: 400 Bad Request"
        )
      end
    end

    context "when API returns 404 not found" do
      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions/#{session_id}/cancel")
          .to_return(status: 404, body: '{"error": {"message": "Session not found"}}', headers: { "Content-Type" => "application/json" })
      end

      it "raises CancelError" do
        instance = described_class.new(session_id:, client:)

        expect { instance.call }.to raise_error(
          ChatKit::Session::Cancel::CancelError,
          "Failed to cancel session: 404 Not Found"
        )
      end
    end

    context "when API returns 500 server error" do
      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions/#{session_id}/cancel")
          .to_return(status: 500, body: '{"error": {"message": "Internal server error"}}', headers: { "Content-Type" => "application/json" })
      end

      it "raises CancelError" do
        instance = described_class.new(session_id:, client:)

        expect { instance.call }.to raise_error(
          ChatKit::Session::Cancel::CancelError,
          "Failed to cancel session: 500 Internal Server Error"
        )
      end
    end

    context "when network error occurs" do
      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions/#{session_id}/cancel")
          .to_raise(StandardError.new("Connection refused"))
      end

      it "raises the network error" do
        instance = described_class.new(session_id:, client:)

        expect { instance.call }.to raise_error(StandardError, "Connection refused")
      end
    end

    context "when timeout occurs" do
      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions/#{session_id}/cancel")
          .to_timeout
      end

      it "raises timeout error" do
        instance = described_class.new(session_id:, client:)

        expect { instance.call }.to raise_error(StandardError)
      end
    end
  end

  describe "private methods" do
    let(:instance) { described_class.new(session_id:, client:) }

    describe "#cancel_session_endpoint" do
      it "returns correct endpoint URL" do
        endpoint = instance.send(:cancel_session_endpoint)

        expect(endpoint).to eq("/v1/chatkit/sessions/#{session_id}/cancel")
      end
    end

    describe "#sessions_header" do
      it "returns correct headers" do
        headers = instance.send(:sessions_header)

        expect(headers).to include(
          "OpenAI-Beta" => "chatkit_beta=v1"
        )
      end
    end
  end
end

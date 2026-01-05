# frozen_string_literal: true

RSpec.describe ChatKit::Session::Create do
  let(:api_key) { "test_api_key_123" }
  let(:host) { "https://api.openai.com" }
  let(:user_id) { "user_123" }
  let(:workflow_params) { { id: "workflow_alpha", version: "2024-10-01" } }
  let(:chatkit_configuration_params) do
    {
      history: { enabled: true },
      file_upload: { enabled: true, max_file_size: 10, max_files: 5 },
      automatic_thread_titling: { enabled: false },
    }
  end
  let(:expires_after_params) { { anchor: "created_at", seconds: 1800 } }
  let(:rate_limits_params) { { max_requests_per_1_minute: 60 } }
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
      it "initializes with user_id and workflow" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          client:
        )

        expect(instance.user_id).to eq(user_id)
        expect(instance.workflow).to be_a(ChatKit::Session::Workflow)
        expect(instance.workflow.id).to eq("workflow_alpha")
      end

      it "converts workflow hash to Workflow object" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          client:
        )

        expect(instance.workflow).to be_a(ChatKit::Session::Workflow)
      end

      it "converts chatkit_configuration hash to ChatKitConfiguration object" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          chatkit_configuration: chatkit_configuration_params,
          client:
        )

        expect(instance.chatkit_configuration).to be_a(ChatKit::Session::ChatKitConfiguration)
      end

      it "converts rate_limits hash to RateLimits object" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          rate_limits: rate_limits_params,
          client:
        )

        expect(instance.rate_limits).to be_a(ChatKit::Session::RateLimits)
      end
    end

    context "when optional arguments are provided" do
      it "initializes with all parameters" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          chatkit_configuration: chatkit_configuration_params,
          expires_after: expires_after_params,
          rate_limits: rate_limits_params,
          client:
        )

        expect(instance.user_id).to eq(user_id)
        expect(instance.workflow).to be_a(ChatKit::Session::Workflow)
        expect(instance.chatkit_configuration).to be_a(ChatKit::Session::ChatKitConfiguration)
        expect(instance.expires_after).to be_a(ChatKit::Session::ExpiresAfter)
        expect(instance.rate_limits).to be_a(ChatKit::Session::RateLimits)
      end

      it "accepts nil for chatkit_configuration" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          chatkit_configuration: nil,
          client:
        )

        expect(instance.chatkit_configuration).to be_a(ChatKit::Session::ChatKitConfiguration)
      end

      it "accepts nil for expires_after" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          expires_after: nil,
          client:
        )

        expect(instance.expires_after).to be_nil
      end

      it "accepts nil for rate_limits" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          rate_limits: nil,
          client:
        )

        expect(instance.rate_limits).to be_a(ChatKit::Session::RateLimits)
      end
    end

    context "when client is not provided" do
      it "creates a new default client" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params
        )

        expect(instance.instance_variable_get(:@client)).to be_a(ChatKit::Client)
      end
    end

    context "when required argument is missing" do
      it "raises ArgumentError without user_id" do
        expect do
          described_class.new(workflow: workflow_params)
        end.to raise_error(ArgumentError)
      end

      it "raises ArgumentError without workflow" do
        expect do
          described_class.new(user_id:)
        end.to raise_error(ArgumentError)
      end
    end
  end

  describe ".call" do
    let(:success_response) { load_fixture("success.json", subdir: "session/create") }

    it "creates a new instance and calls #call" do
      stub_request(:post, "#{host}/v1/chatkit/sessions")
        .with(
          headers: {
            "Authorization" => "Bearer #{api_key}",
            "Accept" => "application/json",
            "Content-Type" => "application/json",
            "OpenAI-Beta" => "chatkit_beta=v1",
          }
        )
        .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })

      result = described_class.call(
        user_id:,
        workflow: workflow_params,
        client:
      )

      expect(result).to be_a(described_class)
      expect(result.response).to be_a(ChatKit::Session::Create::Response)
    end
  end

  describe "#call" do
    let(:success_response) { load_fixture("success.json", subdir: "session/create") }

    context "when API request is successful" do
      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions")
          .with(
            headers: {
              "Authorization" => "Bearer #{api_key}",
              "Accept" => "application/json",
              "Content-Type" => "application/json",
              "OpenAI-Beta" => "chatkit_beta=v1",
            }
          )
          .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })
      end

      it "returns self" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          client:
        )

        result = instance.call
        expect(result).to eq(instance)
      end

      it "sets response attribute" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          client:
        )

        instance.call
        expect(instance.response).to be_a(ChatKit::Session::Create::Response)
        expect(instance.response.id).to eq("sess_abc123")
        expect(instance.response.status).to eq("active")
        expect(instance.response.client_secret).to eq("chatkit_token_123")
      end

      it "sends correct payload" do
        request_stub = stub_request(:post, "#{host}/v1/chatkit/sessions")
          .with(
            headers: {
              "Authorization" => "Bearer #{api_key}",
              "Accept" => "application/json",
              "Content-Type" => "application/json",
              "OpenAI-Beta" => "chatkit_beta=v1",
            },
            body: hash_including(
              "user" => user_id,
              "workflow" => hash_including("id" => "workflow_alpha")
            )
          )
          .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })

        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          client:
        )

        instance.call
        expect(request_stub).to have_been_requested
      end

      it "includes chatkit_configuration in payload when provided" do
        request_stub = stub_request(:post, "#{host}/v1/chatkit/sessions")
          .with(
            body: hash_including(
              "chatkit_configuration" => hash_including("history" => { "enabled" => true })
            )
          )
          .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })

        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          chatkit_configuration: chatkit_configuration_params,
          client:
        )

        instance.call
        expect(request_stub).to have_been_requested
      end

      it "includes expires_after in payload when provided" do
        request_stub = stub_request(:post, "#{host}/v1/chatkit/sessions")
          .with(
            body: hash_including(
              "expires_after" => hash_including("anchor" => "created_at", "seconds" => 1800)
            )
          )
          .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })

        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          expires_after: expires_after_params,
          client:
        )

        instance.call
        expect(request_stub).to have_been_requested
      end

      it "includes rate_limits in payload when provided" do
        request_stub = stub_request(:post, "#{host}/v1/chatkit/sessions")
          .with(
            body: hash_including(
              "rate_limits" => { "max_requests_per_1_minute" => 60 }
            )
          )
          .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })

        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          rate_limits: rate_limits_params,
          client:
        )

        instance.call
        expect(request_stub).to have_been_requested
      end

      it "compacts nil values from payload" do
        request_stub = stub_request(:post, "#{host}/v1/chatkit/sessions")
          .with(
            body: lambda { |body|
              parsed = JSON.parse(body)
              !parsed.key?("expires_after")
            }
          )
          .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })

        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          expires_after: nil,
          client:
        )

        instance.call
        expect(request_stub).to have_been_requested
      end
    end

    context "when API returns 401 Unauthorized" do
      let(:unauthorized_response) { load_fixture("unauthorized.json", subdir: "session/create") }

      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions")
          .to_return(status: 401, body: unauthorized_response, headers: { "Content-Type" => "application/json" })
      end

      it "raises SessionError with authentication error message" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          client:
        )

        expect { instance.call }.to raise_error(
          ChatKit::Session::Create::SessionCreateError,
          "Session creation failed: Missing bearer or basic authentication in header"
        )
      end
    end

    context "when API returns 400 with missing header" do
      let(:missing_header_response) { load_fixture("missing_header.json", subdir: "session/create") }

      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions")
          .to_return(status: 400, body: missing_header_response, headers: { "Content-Type" => "application/json" })
      end

      it "raises SessionError with header error message" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          client:
        )

        expect { instance.call }.to raise_error(
          ChatKit::Session::Create::SessionCreateError,
          /OpenAI-Beta.*chatkit_beta=v1/
        )
      end
    end

    context "when API returns 400 with missing user" do
      let(:missing_user_response) { load_fixture("missing_user.json", subdir: "session/create") }

      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions")
          .to_return(status: 400, body: missing_user_response, headers: { "Content-Type" => "application/json" })
      end

      it "raises SessionError with missing user message" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          client:
        )

        expect { instance.call }.to raise_error(
          ChatKit::Session::Create::SessionCreateError,
          "Session creation failed: Missing required parameter: 'user'."
        )
      end
    end

    context "when API returns 400 with missing workflow" do
      let(:missing_workflow_response) { load_fixture("missing_workflow.json", subdir: "session/create") }

      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions")
          .to_return(status: 400, body: missing_workflow_response, headers: { "Content-Type" => "application/json" })
      end

      it "raises SessionError with missing workflow message" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          client:
        )

        expect { instance.call }.to raise_error(
          ChatKit::Session::Create::SessionCreateError,
          "Session creation failed: Missing required parameter: 'workflow'."
        )
      end
    end

    context "when API returns 404 with workflow not found" do
      let(:workflow_not_found_response) { load_fixture("workflow_not_found.json", subdir: "session/create") }

      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions")
          .to_return(status: 404, body: workflow_not_found_response, headers: { "Content-Type" => "application/json" })
      end

      it "raises SessionError with workflow not found message" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          client:
        )

        expect { instance.call }.to raise_error(
          ChatKit::Session::Create::SessionCreateError,
          /Workflow with id.*not found/
        )
      end
    end

    context "when API returns error without proper JSON structure" do
      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions")
          .to_return(status: 500, body: "Internal Server Error", headers: { "Content-Type" => "text/plain" })
      end

      it "raises SessionError with unknown error message" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          client:
        )

        expect { instance.call }.to raise_error(
          ChatKit::Session::Create::SessionCreateError,
          "Session creation failed: Unknown error occurred"
        )
      end
    end

    context "when network error occurs" do
      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions")
          .to_raise(StandardError.new("Connection refused"))
      end

      it "raises SessionError with network error message" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          client:
        )

        expect { instance.call }.to raise_error(
          ChatKit::Session::Create::SessionCreateError,
          "Session creation failed: Connection refused"
        )
      end
    end
  end

  describe "#refresh!" do
    let(:success_response) { load_fixture("success.json", subdir: "session/create") }

    before do
      stub_request(:post, "#{host}/v1/chatkit/sessions")
        .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })
    end

    it "calls #call method" do
      instance = described_class.new(
        user_id:,
        workflow: workflow_params,
        client:
      )

      expect(instance).to receive(:call).and_call_original
      instance.refresh!
    end

    it "updates the response" do
      instance = described_class.new(
        user_id:,
        workflow: workflow_params,
        client:
      )

      instance.refresh!
      first_response = instance.response

      # Stub with different response
      new_response = success_response.gsub("sess_abc123", "sess_xyz789")
      stub_request(:post, "#{host}/v1/chatkit/sessions")
        .to_return(status: 200, body: new_response, headers: { "Content-Type" => "application/json" })

      instance.refresh!
      expect(instance.response.id).to eq("sess_xyz789")
    end
  end

  describe "attribute accessors" do
    let(:instance) do
      described_class.new(
        user_id:,
        workflow: workflow_params,
        client:
      )
    end

    describe "#user_id" do
      it "allows reading the user_id value" do
        expect(instance.user_id).to eq(user_id)
      end

      it "allows writing new user_id value" do
        instance.user_id = "user_456"
        expect(instance.user_id).to eq("user_456")
      end
    end

    describe "#workflow" do
      it "allows reading the workflow value" do
        expect(instance.workflow).to be_a(ChatKit::Session::Workflow)
      end

      it "allows writing new workflow value" do
        new_workflow = ChatKit::Session::Workflow.new(id: "wf_new")
        instance.workflow = new_workflow
        expect(instance.workflow).to eq(new_workflow)
      end
    end

    describe "#chatkit_configuration" do
      it "allows reading the chatkit_configuration value" do
        expect(instance.chatkit_configuration).to be_a(ChatKit::Session::ChatKitConfiguration)
      end

      it "allows writing new chatkit_configuration value" do
        new_config = ChatKit::Session::ChatKitConfiguration.new
        instance.chatkit_configuration = new_config
        expect(instance.chatkit_configuration).to eq(new_config)
      end
    end

    describe "#expires_after" do
      it "allows reading the expires_after value" do
        expect(instance.expires_after).to be_nil
      end

      it "allows writing new expires_after value" do
        new_expires = ChatKit::Session::ExpiresAfter.new(anchor: "created_at", seconds: 3600)
        instance.expires_after = new_expires
        expect(instance.expires_after).to eq(new_expires)
      end
    end

    describe "#rate_limits" do
      it "allows reading the rate_limits value" do
        expect(instance.rate_limits).to be_a(ChatKit::Session::RateLimits)
      end

      it "allows writing new rate_limits value" do
        new_limits = ChatKit::Session::RateLimits.new(max_requests_per_1_minute: 100)
        instance.rate_limits = new_limits
        expect(instance.rate_limits).to eq(new_limits)
      end
    end

    describe "#response" do
      let(:success_response) { load_fixture("success.json", subdir: "session/create") }

      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions")
          .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })

        instance.call
      end

      it "allows reading the response value after call" do
        expect(instance.response).to be_a(ChatKit::Session::Create::Response)
      end

      it "allows writing new response value" do
        new_response = build(:base_response)
        instance.response = new_response
        expect(instance.response).to eq(new_response)
      end
    end
  end

  describe "private methods" do
    let(:instance) do
      described_class.new(
        user_id:,
        workflow: workflow_params,
        chatkit_configuration: chatkit_configuration_params,
        expires_after: expires_after_params,
        rate_limits: rate_limits_params,
        client:
      )
    end

    describe "#build_payload" do
      it "builds correct payload with all parameters" do
        payload = instance.send(:build_payload)

        expect(payload).to include(:user, :workflow, :chatkit_configuration, :rate_limits)
        expect(payload[:user]).to eq(user_id)
        expect(payload[:workflow]).to be_a(Hash)
        expect(payload[:workflow]).to include(:id)
        expect(payload[:chatkit_configuration]).to be_a(Hash)
        expect(payload[:rate_limits]).to be_a(Hash)
      end

      it "includes expires_after when present" do
        payload = instance.send(:build_payload)
        expect(payload).to have_key(:expires_after)
      end

      it "excludes expires_after when nil" do
        instance_without_expires = described_class.new(
          user_id:,
          workflow: workflow_params,
          expires_after: nil,
          client:
        )

        payload = instance_without_expires.send(:build_payload)
        expect(payload).not_to have_key(:expires_after)
      end

      it "serializes nested objects" do
        payload = instance.send(:build_payload)

        expect(payload[:workflow]).to be_a(Hash)
        expect(payload[:chatkit_configuration]).to be_a(Hash)
        expect(payload[:rate_limits]).to be_a(Hash)
      end
    end

    describe "#create_session_endpoint" do
      it "returns correct endpoint" do
        endpoint = instance.send(:create_session_endpoint)
        expect(endpoint).to eq("/v1/chatkit/sessions")
      end
    end

    describe "#sessions_header" do
      it "returns correct headers" do
        headers = instance.send(:sessions_header)
        expect(headers).to include(
          "Accept" => "application/json",
          "Content-Type" => "application/json",
          "OpenAI-Beta" => "chatkit_beta=v1"
        )
      end
    end
  end

  describe "integration scenarios" do
    let(:success_response) { load_fixture("success.json", subdir: "session/create") }

    context "creating a minimal session" do
      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions")
          .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })
      end

      it "creates session with only required parameters" do
        session = described_class.new(
          user_id: "user_minimal",
          workflow: { id: "wf_simple" },
          client:
        )

        result = session.call

        expect(result.response).to be_a(ChatKit::Session::Create::Response)
        expect(result.response.status).to eq("active")
      end
    end

    context "creating a fully configured session" do
      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions")
          .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })
      end

      it "creates session with all parameters" do
        session = described_class.new(
          user_id: "user_full",
          workflow: { id: "wf_full", version: "1.0.0" },
          chatkit_configuration: {
            history: { enabled: true },
            file_upload: { enabled: true },
          },
          expires_after: { anchor: "created_at", seconds: 3600 },
          rate_limits: { max_requests_per_1_minute: 100 },
          client:
        )

        result = session.call

        expect(result.response).to be_a(ChatKit::Session::Create::Response)
        expect(result.user_id).to eq("user_full")
        expect(result.workflow.id).to eq("wf_full")
      end
    end

    context "refreshing an existing session" do
      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions")
          .to_return(status: 200, body: success_response, headers: { "Content-Type" => "application/json" })
      end

      it "can refresh session multiple times" do
        session = described_class.new(
          user_id:,
          workflow: workflow_params,
          client:
        )

        session.call
        first_response_id = session.response.id

        session.refresh!
        second_response_id = session.response.id

        expect(first_response_id).to eq(second_response_id)
      end
    end
  end

  describe "error handling edge cases" do
    context "when response has malformed JSON" do
      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions")
          .to_return(status: 400, body: "Not a JSON", headers: { "Content-Type" => "text/plain" })
      end

      it "raises SessionError with unknown error" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          client:
        )

        expect { instance.call }.to raise_error(
          ChatKit::Session::Create::SessionCreateError,
          /Session creation failed/
        )
      end
    end

    context "when response has error without message field" do
      before do
        stub_request(:post, "#{host}/v1/chatkit/sessions")
          .to_return(
            status: 500,
            body: '{"error": {"type": "server_error"}}',
            headers: { "Content-Type" => "application/json" }
          )
      end

      it "raises SessionError with unknown error" do
        instance = described_class.new(
          user_id:,
          workflow: workflow_params,
          client:
        )

        expect { instance.call }.to raise_error(
          ChatKit::Session::Create::SessionCreateError
        ) do |error|
          expect(error.message).to match(/Session creation failed/)
        end
      end
    end
  end

  describe "class constant" do
    describe "Defaults::ENABLED" do
      it "has correct value" do
        expect(ChatKit::Session::Defaults::ENABLED).to eq(true)
      end
    end
  end

  describe "SessionCreateError" do
    it "is defined as a StandardError subclass" do
      expect(described_class::SessionCreateError).to be < StandardError
    end
  end
end

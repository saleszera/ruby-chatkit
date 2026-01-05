# frozen_string_literal: true

require "spec_helper"
require "http"

RSpec.describe ChatKit::Client do
  let(:test_api_key) { "test_api_key_123" }
  let(:test_host) { "https://test-api.openai.com" }

  describe "::OpenAI" do
    it "defines the OpenAI HOST constant" do
      expect(described_class::OpenAI::HOST).to eq("https://api.openai.com")
    end
  end

  describe ".new" do
    context "when no parameters are provided" do
      it "uses configuration defaults" do
        ChatKit.configuration = build(:config, api_key: "factory_config_api_key", host: ChatKit::Client::OpenAI::HOST)
        client = described_class.new

        expect(client.api_key).to eq("factory_config_api_key")
        expect(client.host).to eq(ChatKit::Client::OpenAI::HOST)
      end
    end

    context "when both parameters are provided" do
      it "overrides configuration values" do
        ChatKit.configuration = build(:config, api_key: "config_key", host: "https://config.com")
        client = described_class.new(api_key: test_api_key, host: test_host)

        expect(client.api_key).to eq(test_api_key)
        expect(client.host).to eq(test_host)
      end
    end

    context "when only api_key is provided" do
      it "uses provided api_key and default host from configuration" do
        ChatKit.configuration = build(:config, host: ChatKit::Client::OpenAI::HOST)
        client = described_class.new(api_key: test_api_key)

        expect(client.api_key).to eq(test_api_key)
        expect(client.host).to eq(ChatKit::Client::OpenAI::HOST)
      end
    end

    context "when only host is provided" do
      it "uses provided host and default api_key from configuration" do
        ChatKit.configuration = build(:config, api_key: "default_config_api_key")
        client = described_class.new(host: test_host)

        expect(client.api_key).to eq("default_config_api_key")
        expect(client.host).to eq(test_host)
      end

      it "works with nil api_key from config" do
        ChatKit.configuration = build(:config, :with_nil_api_key)
        client = described_class.new(host: test_host)

        expect(client.api_key).to be_nil
        expect(client.host).to eq(test_host)
      end
    end

    context "when nil values are provided" do
      it "accepts nil api_key" do
        client = described_class.new(api_key: nil, host: test_host)

        expect(client.api_key).to be_nil
        expect(client.host).to eq(test_host)
      end

      it "accepts nil host" do
        client = described_class.new(api_key: test_api_key, host: nil)

        expect(client.api_key).to eq(test_api_key)
        expect(client.host).to be_nil
      end
    end

    context "when empty string values are provided" do
      it "accepts empty string api_key" do
        client = described_class.new(api_key: "", host: test_host)

        expect(client.api_key).to eq("")
        expect(client.host).to eq(test_host)
      end

      it "accepts empty string host" do
        client = described_class.new(api_key: test_api_key, host: "")

        expect(client.api_key).to eq(test_api_key)
        expect(client.host).to eq("")
      end
    end

    context "with different host formats" do
      it "accepts OpenAI production host" do
        client = described_class.new(api_key: test_api_key, host: ChatKit::Client::OpenAI::HOST)

        expect(client.host).to eq("https://api.openai.com")
      end

      it "accepts localhost development host" do
        localhost_host = "http://localhost:3000"
        client = described_class.new(api_key: test_api_key, host: localhost_host)

        expect(client.host).to eq(localhost_host)
      end

      it "accepts custom domain host" do
        custom_host = "https://custom-chatkit.example.com"
        client = described_class.new(api_key: test_api_key, host: custom_host)

        expect(client.host).to eq(custom_host)
      end
    end
  end

  describe "attribute accessors" do
    before { ChatKit.configuration = build(:config, api_key: test_api_key, host: test_host) }

    let(:client) { described_class.new(api_key: test_api_key, host: test_host) }

    describe "#api_key" do
      it "is readable and writable" do
        expect(client.api_key).to eq(test_api_key)
        client.api_key = "new_api_key"
        expect(client.api_key).to eq("new_api_key")
      end

      it "accepts nil value" do
        client.api_key = nil
        expect(client.api_key).to be_nil
      end

      it "accepts empty string" do
        client.api_key = ""
        expect(client.api_key).to eq("")
      end

      it "accepts different API key formats" do
        sk_key = "sk-1234567890abcdef"
        client.api_key = sk_key
        expect(client.api_key).to eq(sk_key)
      end
    end

    describe "#host" do
      it "is readable and writable" do
        expect(client.host).to eq(test_host)
        client.host = "https://new-host.com"
        expect(client.host).to eq("https://new-host.com")
      end

      it "accepts nil value" do
        client.host = nil
        expect(client.host).to be_nil
      end

      it "accepts different URL formats" do
        urls = [
          "https://api.openai.com",
          "http://localhost:3000",
          "https://custom.domain.com:8080",
        ]

        urls.each do |url|
          client.host = url
          expect(client.host).to eq(url)
        end
      end
    end
  end

  describe "#connection" do
    let(:client) { described_class.new(api_key: test_api_key, host: test_host) }
    let(:mock_http_base) { instance_double(HTTP::Client) }
    let(:mock_http_connection) { instance_double(HTTP::Client) }

    before do
      ChatKit.configuration = build(:config, api_key: test_api_key, host: test_host)

      allow(HTTP).to receive(:persistent).with(test_host).and_return(mock_http_base)
      allow(mock_http_base).to receive(:auth).with("Bearer #{test_api_key}").and_return(mock_http_connection)
    end

    it "creates a persistent HTTP connection" do
      connection = client.connection

      expect(HTTP).to have_received(:persistent).with(test_host)
      expect(connection).to eq(mock_http_connection)
    end

    it "memoizes the connection" do
      first_connection = client.connection
      second_connection = client.connection

      expect(HTTP).to have_received(:persistent).once
      expect(first_connection).to eq(second_connection)
      expect(first_connection).to be(second_connection)
    end

    it "uses the current host value" do
      client.connection
      expect(HTTP).to have_received(:persistent).with(test_host)
    end

    context "when host is changed after connection is established" do
      it "continues to use the original connection" do
        original_connection = client.connection
        client.host = "https://different-host.com"
        same_connection = client.connection

        expect(original_connection).to be(same_connection)
        expect(HTTP).to have_received(:persistent).once.with(test_host)
      end
    end

    context "when host is nil" do
      let(:client) { described_class.new(api_key: test_api_key, host: nil) }
      let(:mock_http_base_nil) { instance_double(HTTP::Client) }
      let(:mock_http_connection_nil) { instance_double(HTTP::Client) }

      it "creates connection with nil host" do
        allow(HTTP).to receive(:persistent).with(nil).and_return(mock_http_base_nil)
        allow(mock_http_base_nil).to receive(:auth).with("Bearer #{test_api_key}").and_return(mock_http_connection_nil)

        connection = client.connection

        expect(HTTP).to have_received(:persistent).with(nil)
        expect(mock_http_base_nil).to have_received(:auth).with("Bearer #{test_api_key}")
        expect(connection).to eq(mock_http_connection_nil)
      end
    end

    context "when api_key is nil" do
      let(:client) { described_class.new(api_key: nil, host: test_host) }
      let(:mock_http_base_no_auth) { instance_double(HTTP::Client) }

      it "does not call auth method when api_key is nil" do
        allow(HTTP).to receive(:persistent).with(test_host).and_return(mock_http_base_no_auth)

        connection = client.connection

        expect(HTTP).to have_received(:persistent).with(test_host)
        expect(connection).to eq(mock_http_base_no_auth)
      end
    end
  end

  describe "integration with configuration" do
    it "uses configuration values as defaults" do
      ChatKit.configuration = build(:config, api_key: "config_key", host: "https://config.com")
      client = described_class.new

      expect(client.api_key).to eq("config_key")
      expect(client.host).to eq("https://config.com")
    end

    it "partially overrides configuration" do
      ChatKit.configuration = build(:config, api_key: "config_key", host: "https://config.com")
      client = described_class.new(api_key: "explicit_key")

      expect(client.api_key).to eq("explicit_key")
      expect(client.host).to eq("https://config.com")
    end
  end

  describe "edge cases and validation" do
    context "with boundary values" do
      it "handles very long API key" do
        long_key = "sk_#{'a' * 1000}"
        client = described_class.new(api_key: long_key, host: test_host)
        expect(client.api_key).to eq(long_key)
      end

      it "handles very long host URL" do
        long_host = "https://#{'subdomain.' * 50}example.com"
        client = described_class.new(api_key: test_api_key, host: long_host)
        expect(client.host).to eq(long_host)
      end

      it "handles special characters in API key" do
        special_key = "sk-test!@#$%^&*()_+-=[]{}|;':,.<>?"
        client = described_class.new(api_key: special_key, host: test_host)
        expect(client.api_key).to eq(special_key)
      end
    end

    context "with different initialization patterns" do
      it "works with keyword arguments" do
        client = described_class.new(api_key: test_api_key, host: test_host)
        expect(client.api_key).to eq(test_api_key)
        expect(client.host).to eq(test_host)
      end

      it "works with hash splat" do
        params = { api_key: test_api_key, host: test_host }
        client = described_class.new(**params)
        expect(client.api_key).to eq(test_api_key)
        expect(client.host).to eq(test_host)
      end
    end

    context "when connection creation fails" do
      let(:client) { described_class.new(api_key: test_api_key, host: test_host) }

      it "propagates HTTP connection errors" do
        allow(HTTP).to receive(:persistent).and_raise(StandardError, "Connection failed")

        expect { client.connection }.to raise_error(StandardError, "Connection failed")
      end
    end
  end
end

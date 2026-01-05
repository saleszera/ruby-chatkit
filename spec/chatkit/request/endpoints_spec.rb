# frozen_string_literal: true

RSpec.describe ChatKit::Request::Endpoints do
  describe ".conversation_endpoint" do
    it "returns the correct conversation endpoint" do
      expect(described_class.conversation_endpoint).to eq("/v1/chatkit/conversation")
    end
  end

  describe ".create_session_endpoint" do
    it "returns the correct sessions endpoint" do
      expect(described_class.create_session_endpoint).to eq("/v1/chatkit/sessions")
    end
  end

  describe "error handling for undefined endpoints" do
    it "raises NoMethodError for undefined endpoint" do
      expect do
        described_class.undefined_endpoint
      end.to raise_error(NoMethodError)
    end
  end
end

# frozen_string_literal: true

module ChatKit
  module Request
    # Module defining request headers for ChatKit API
    # Usage:
    #  Chatkit::Request::Headers.conversation_header
    #  Chatkit::Request::Headers.sessions_header
    module Headers
      CONVERSATION = {
        "Content-Type" => "application/json",
        "Accept" => "text/event-stream",
        "Cache-Control" => "no-cache",
      }.freeze

      SESSIONS = {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "OpenAI-Beta" => "chatkit_beta=v1",
      }.freeze

      class << self
        ChatKit::Request::Headers.constants.each do |const_name|
          define_method "#{const_name.downcase}_header" do
            ChatKit::Request::Headers.const_get(const_name)
          end
        end
      end
    end
  end
end

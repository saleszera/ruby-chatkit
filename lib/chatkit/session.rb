# frozen_string_literal: true

require "json"

# Manage ChatKit sessions, threads, and file uploads for internal integrations.
module ChatKit
  # Represents a ChatKit session.
  #
  # Source: https://platform.openai.com/docs/api-reference/chatkit/sessions/create
  # Usage:
  #  ChatKit.configure do |config|
  #    config.client_secret = "your_client_secret"
  #  end
  #
  #  ChatKit::Session.create!(
  #    user_id: "user_12345",
  #    workflow: { id: "wf_68eeb857eaf8819089eb55d32f39a822050622537973ef99" }
  #  )
  class Session
    class SessionError < StandardError; end

    module Defaults
      ENABLED = true
    end

    # @!attribute [rw] sesstion
    #  @return [Session::Create]
    attr_accessor :session

    def initialize
      @session = nil
    end

    class << self
      def create!(
        user_id:,
        workflow:,
        chatkit_configuration: nil,
        expires_after: nil,
        rate_limits: nil,
        client: Client.new
      )
        new.tap do |instance|
          instance.session = Create.call(
            user_id:,
            workflow:,
            chatkit_configuration:,
            expires_after:,
            rate_limits:,
            client:
          )
        end
      end

      def cancel!(session_id:, client: Client.new)
        Cancel.call(session_id:, client:)
      end
    end

    # Cancel the current session.
    #
    # @raise [SessionError] If there is no session to cancel.
    # @return [void]
    def cancel!
      raise SessionError, "No session available to cancel" if @session.nil?

      Cancel.call(session_id: session.response.id)
    ensure
      @session = nil
    end

    # Refresh the current session.
    #   @return [Session::Create] The refreshed session.
    def refresh!
      raise SessionError, "No session available to refresh" if @session.nil?

      session.call
    end
  end
end

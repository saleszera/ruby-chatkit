# frozen_string_literal: true

require "uri"
require "http"
require "event_stream_parser"
require "net/http"
require "zeitwerk"
require "pry"

loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/ruby")
loader.inflector.inflect "chatkit" => "ChatKit"
loader.inflector.inflect "chatkit_error" => "ChatKitError"
loader.inflector.inflect "chatkit_configuration" => "ChatKitConfiguration"
loader.enable_reloading
loader.setup

# Main module for the ChatKit library.
module ChatKit
  class Error < StandardError; end

  class << self
    # @!attribute [rw] configuration
    #   @return [ChatKit::Config] The configuration for the Chatkit module.
    attr_accessor :configuration

    # @!attribute [rw] current_session
    #   @return [ChatKit::CurrentSession] The current ChatKit session.
    attr_accessor :current_session

    def configure
      self.configuration ||= Config.new
      self.current_session ||= CurrentSession.new

      yield(configuration) if block_given?
    end
  end
end

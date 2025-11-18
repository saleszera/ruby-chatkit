# frozen_string_literal: true

module ChatKit
  # Module for dynamically creating ChatKit error classes.
  module ChatKitError
    class << self
      # Dynamically creates and returns an error class.
      # @param klass [String] The base name of the error class.
      # @param message [String] The default error message.
      # @return [Class] The dynamically created error class.
      def set_error(klass, message)
        klass_name = "#{klass}Error"

        # Create the error class dynamically if it doesn't exist
        unless ChatKit.const_defined?(klass_name)
          error_class = Class.new(ChatKit::Error) do
            define_method :initialize do |msg = message|
              super(msg)
            end
          end

          ChatKit.const_set(klass_name, error_class)
        end

        ChatKit.const_get(klass_name)
      end
    end
  end
end

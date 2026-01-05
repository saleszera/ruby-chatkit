# frozen_string_literal: true

module ChatKit
  class Session
    class Cancel
      # Represents scope from cancel session response.
      class Scope
        # @!attribute [rw] customer_id
        #   @return [String]
        attr_accessor :customer_id

        # param customer_id [String] The ID of the scope.
        def initialize(customer_id:)
          @customer_id = customer_id
        end

        class << self
          def deserialize(data)
            new(
              customer_id: data&.dig("customer_id")
            )
          end
        end
      end
    end
  end
end

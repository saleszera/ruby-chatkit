# frozen_string_literal: true

module ChatKit
  # Represents the current ChatKit information.
  class CurrentInfo
    # @!attribute [r] session
    #  @return [Hash] The session.
    attr_accessor :session

    # @!attribute [r] conversation
    #  @return [Hash] The conversation.
    attr_accessor :conversation
  end
end

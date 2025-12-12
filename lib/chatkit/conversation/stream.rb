# frozen_string_literal: true

module ChatKit
  class Conversation
    # Represents a stream of conversation data.
    class Stream
      # @param chunks [Array<Hash>] The array of streamed chunks.
      # @param logger [Logger, nil] The logger instance to use for logging.
      def initialize(chunks, logger = nil)
        @chunks = chunks
        @logger = logger
      end

      def stream!(&block)
        @chunks.body.each do |chunk|
          parser.feed(chunk) do |_, data|
            process!(data, &block)
          end
        end
      end

    private

      # @param data [String] The raw data chunk.
      # @return [void]
      def log(data)
        return unless @logger

        @logger.debug("Stream chunk: #{data}")
      end

      # @param data [String] The raw data chunk.
      # @yield [parsed_data] Yields the parsed data.
      #  @return [void]
      def process!(data)
        log(data)

        parsed_data = JSON.parse(data)

        yield(parsed_data) if block_given?
      end

      # @return [EventStreamParser::Parser]
      def parser
        @parser ||= EventStreamParser::Parser.new
      end
    end
  end
end

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
          parser.feed(string_sanitize(chunk)) do |_, data|
            process!(data, &block)
          end
        rescue ArgumentError => e
          log("Failed to parse chunk: #{e.message}\nChunk: #{chunk}", kind: :error)

          raise
        end
      end

    private

      # @param data [String] The raw data chunk.
      # @return [void]
      def log(data, kind: :debug)
        return unless @logger

        @logger.send(kind, "Stream chunk: #{data}")
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

      # @param str [String] The string to sanitize.
      # @return [String]
      def string_sanitize(str)
        return str if str.valid_encoding?

        str.encode("UTF-8", "ISO-8859-1", invalid: :replace, undef: :replace)
      end
    end
  end
end

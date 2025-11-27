# frozen_string_literal: true

module ChatKit
  class Files
    # Response object for file upload
    class Response
      # @!attribute [rw] id
      #  @return [String]
      attr_accessor :id

      # @!attribute [rw] mime_type
      #  @return [String]
      attr_accessor :mime_type

      # @!attribute [rw] name
      #  @return [String]
      attr_accessor :name

      # @!attribute [rw] preview_url
      #  @return [String]
      attr_accessor :preview_url

      # @!attribute [rw] type
      #  @return [String]
      attr_accessor :type

      # @!attribute [rw] upload_url
      #  @return [String]
      attr_accessor :upload_url

      # @param id [String] - The file ID.
      # @param mime_type [String] - The MIME type of the file.
      # @param name [String] - The name of the file.
      # @param preview_url [String] - The preview URL of the file.
      # @param type [String] - The type of the file.
      # @param upload_url [String] - The upload URL of the file.
      def initialize(id:, mime_type:, name:, preview_url:, type:, upload_url:)
        @id = id
        @mime_type = mime_type
        @name = name
        @preview_url = preview_url
        @type = type
        @upload_url = upload_url
      end

      class << self
        def deserialize(data)
          new(
            id: data["id"],
            mime_type: data["mime_type"],
            name: data["name"],
            preview_url: data["preview_url"],
            type: data["type"],
            upload_url: data["upload_url"]
          )
        end
      end
    end
  end
end

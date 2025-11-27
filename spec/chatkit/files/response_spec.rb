# frozen_string_literal: true

require "spec_helper"

RSpec.describe ChatKit::Files::Response do
  # Helper method to create sample data
  def sample_response_data
    {
      "id" => "file_abc123",
      "mime_type" => "image/png",
      "name" => "example.png",
      "preview_url" => "https://example.com/preview/file_abc123",
      "type" => "image",
      "upload_url" => "https://example.com/upload/file_abc123",
    }
  end

  describe ".new" do
    context "when all required arguments are provided" do
      it "initializes with all provided values" do
        response = described_class.new(
          id: "file_test123",
          mime_type: "application/pdf",
          name: "document.pdf",
          preview_url: "https://example.com/preview/file_test123",
          type: "document",
          upload_url: "https://example.com/upload/file_test123"
        )

        expect(response.id).to eq("file_test123")
        expect(response.mime_type).to eq("application/pdf")
        expect(response.name).to eq("document.pdf")
        expect(response.preview_url).to eq("https://example.com/preview/file_test123")
        expect(response.type).to eq("document")
        expect(response.upload_url).to eq("https://example.com/upload/file_test123")
      end
    end

    context "when required arguments are missing" do
      it "raises an ArgumentError when id is missing" do
        expect do
          described_class.new(
            mime_type: "application/pdf",
            name: "document.pdf",
            preview_url: "https://example.com/preview",
            type: "document",
            upload_url: "https://example.com/upload"
          )
        end.to raise_error(ArgumentError, /missing keyword.*id/)
      end

      it "raises an ArgumentError when mime_type is missing" do
        expect do
          described_class.new(
            id: "file_test123",
            name: "document.pdf",
            preview_url: "https://example.com/preview",
            type: "document",
            upload_url: "https://example.com/upload"
          )
        end.to raise_error(ArgumentError, /missing keyword.*mime_type/)
      end

      it "raises an ArgumentError when name is missing" do
        expect do
          described_class.new(
            id: "file_test123",
            mime_type: "application/pdf",
            preview_url: "https://example.com/preview",
            type: "document",
            upload_url: "https://example.com/upload"
          )
        end.to raise_error(ArgumentError, /missing keyword.*name/)
      end

      it "raises an ArgumentError when preview_url is missing" do
        expect do
          described_class.new(
            id: "file_test123",
            mime_type: "application/pdf",
            name: "document.pdf",
            type: "document",
            upload_url: "https://example.com/upload"
          )
        end.to raise_error(ArgumentError, /missing keyword.*preview_url/)
      end

      it "raises an ArgumentError when type is missing" do
        expect do
          described_class.new(
            id: "file_test123",
            mime_type: "application/pdf",
            name: "document.pdf",
            preview_url: "https://example.com/preview",
            upload_url: "https://example.com/upload"
          )
        end.to raise_error(ArgumentError, /missing keyword.*type/)
      end

      it "raises an ArgumentError when upload_url is missing" do
        expect do
          described_class.new(
            id: "file_test123",
            mime_type: "application/pdf",
            name: "document.pdf",
            preview_url: "https://example.com/preview",
            type: "document"
          )
        end.to raise_error(ArgumentError, /missing keyword.*upload_url/)
      end
    end
  end

  describe ".deserialize" do
    context "with valid data" do
      it "creates a Response object from hash data" do
        data = sample_response_data
        response = described_class.deserialize(data)

        expect(response).to be_a(described_class)
        expect(response.id).to eq("file_abc123")
        expect(response.mime_type).to eq("image/png")
        expect(response.name).to eq("example.png")
        expect(response.preview_url).to eq("https://example.com/preview/file_abc123")
        expect(response.type).to eq("image")
        expect(response.upload_url).to eq("https://example.com/upload/file_abc123")
      end

      it "handles different file types" do
        data = {
          "id" => "file_video123",
          "mime_type" => "video/mp4",
          "name" => "video.mp4",
          "preview_url" => "https://example.com/preview/file_video123",
          "type" => "video",
          "upload_url" => "https://example.com/upload/file_video123",
        }

        response = described_class.deserialize(data)

        expect(response.mime_type).to eq("video/mp4")
        expect(response.type).to eq("video")
        expect(response.name).to eq("video.mp4")
      end

      it "handles text files" do
        data = {
          "id" => "file_text123",
          "mime_type" => "text/plain",
          "name" => "readme.txt",
          "preview_url" => "https://example.com/preview/file_text123",
          "type" => "text",
          "upload_url" => "https://example.com/upload/file_text123",
        }

        response = described_class.deserialize(data)

        expect(response.mime_type).to eq("text/plain")
        expect(response.type).to eq("text")
        expect(response.name).to eq("readme.txt")
      end
    end

    context "with missing data" do
      it "sets id to nil when missing" do
        data = sample_response_data.except("id")

        response = described_class.deserialize(data)

        expect(response.id).to be_nil
      end

      it "sets mime_type to nil when mime_type is missing" do
        data = sample_response_data.except("mime_type")

        response = described_class.deserialize(data)

        expect(response.mime_type).to be_nil
      end

      it "sets name to nil when missing" do
        data = sample_response_data.except("name")

        response = described_class.deserialize(data)

        expect(response.name).to be_nil
      end

      it "sets preview_url to nil when missing" do
        data = sample_response_data.except("preview_url")

        response = described_class.deserialize(data)

        expect(response.preview_url).to be_nil
      end

      it "sets type to nil when missing" do
        data = sample_response_data.except("type")

        response = described_class.deserialize(data)

        expect(response.type).to be_nil
      end

      it "sets upload_url to nil when missing" do
        data = sample_response_data.except("upload_url")

        response = described_class.deserialize(data)

        expect(response.upload_url).to be_nil
      end
    end
  end

  describe "attribute accessors" do
    let(:response) do
      described_class.new(
        id: "file_test123",
        mime_type: "image/jpeg",
        name: "photo.jpg",
        preview_url: "https://example.com/preview/file_test123",
        type: "image",
        upload_url: "https://example.com/upload/file_test123"
      )
    end

    it "allows reading and writing id" do
      expect(response.id).to eq("file_test123")
      response.id = "file_new123"
      expect(response.id).to eq("file_new123")
    end

    it "allows reading and writing mime_type" do
      expect(response.mime_type).to eq("image/jpeg")
      response.mime_type = "image/png"
      expect(response.mime_type).to eq("image/png")
    end

    it "allows reading and writing name" do
      expect(response.name).to eq("photo.jpg")
      response.name = "updated_photo.jpg"
      expect(response.name).to eq("updated_photo.jpg")
    end

    it "allows reading and writing preview_url" do
      expect(response.preview_url).to eq("https://example.com/preview/file_test123")
      response.preview_url = "https://example.com/preview/new_url"
      expect(response.preview_url).to eq("https://example.com/preview/new_url")
    end

    it "allows reading and writing type" do
      expect(response.type).to eq("image")
      response.type = "document"
      expect(response.type).to eq("document")
    end

    it "allows reading and writing upload_url" do
      expect(response.upload_url).to eq("https://example.com/upload/file_test123")
      response.upload_url = "https://example.com/upload/new_url"
      expect(response.upload_url).to eq("https://example.com/upload/new_url")
    end
  end
end

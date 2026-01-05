# frozen_string_literal: true

module ChatKit
  # Client for interacting with the ChatKit service.
  class Client
    module OpenAI
      HOST = "https://api.openai.com"
    end

    # @!attribute [rw] api_key
    #  @return [String] The API key for authenticating requests.
    attr_accessor :api_key

    # @!attribute [rw] host
    #  @return [String] The host URL for the ChatKit service.
    attr_accessor :host

    # @!attribute [rw] timeout
    #  @return [Integer, nil] The timeout for requests.
    attr_accessor :timeout

    # @!attribute [rw] current_session
    #  @return [ChatKit::Session, nil] The current session.
    attr_accessor :current_session

    # @param api_key [String, nil] - optional - The API key for authenticating requests.
    # @param host [String] - optional - The host URL for the ChatKit service.
    # @param timeout [Integer, nil] - optional - The timeout for requests.
    # @param logger [Logger, nil] - optional - The logger instance.
    def initialize(
      api_key: ChatKit.configuration.api_key, 
      host: ChatKit.configuration.host,
      timeout: ChatKit.configuration.timeout,
      logger: nil
      )
      @api_key = api_key
      @host = host
      @timeout = timeout
      @logger = logger
      @current_session = nil
    end

    # @return [HTTP]
    def connection
      @connection ||= begin
        http = HTTP.persistent(@host)
        http = http.use(instrumentation: { instrumenter: Instrumentation.new(@logger) }) if @logger
        http = http.auth("Bearer #{@api_key}") if @api_key
        http = http.timeout(@timeout) if @timeout

        http
      end
    end

    # Creates a new ChatKit session.
    # @param user_id [String] The ID of the user.
    # @param workflow_id [String] The ID of the workflow.
    # @param chatkit_configuration [Hash, nil] - optional - The ChatKit configuration.
    # @param expires_after [Hash, nil] - optional - The expiration time for the session.
    # @param rate_limits [Hash, nil] - optional - The rate limits for the session.
    # @return [ChatKit::Session] The created session.
    def create_session!(user_id:, workflow_id:, chatkit_configuration: nil, expires_after: nil, rate_limits: nil)
      @current_session = Session.create!(
        client: self,
        user_id:,
        workflow: { id: workflow_id },
        chatkit_configuration:,
        expires_after:,
        rate_limits:
      )
    end

    # Cancels the current session or a specified session by ID.
    # @param session_id [String] - The ID of the session to cancel.
    #
    # @raise [RuntimeError] If no session ID is provided and there is no current session.
    # @return [Session::Cancel::Response] The response from the cancel operation.
    def cancel_session!(session_id:)
      raise "No session ID provided" if session_id.nil?

      Session.cancel!(session_id:, client: self)
    end

    # Sends a message in a conversation, optionally uploading files.
    # @param text [String] The text message to send.
    # @param files [Array<File>] - optional - The files to upload and attach to the message.
    # @param client [ChatKit::Client] The ChatKit client instance.
    #
    # @return [ChatKit::Conversation::Response] The response from the conversation.
    def send_message!(text:, client_secret: nil, files: nil, client: self)
      client_secret ||= @current_session.response.client_secret

      refresh_session! if refresh_session?

      attachments = files&.map do |file|
        upload_file!(file:, client_secret:)
      end

      conversation = Conversation.send_message!(
        client_secret:,
        text:,
        attachments:,
        client:,
        logger: @logger
      )

      conversation.response.answer
    end

  private

    # Determines if the current session needs to be refreshed.
    # @return [Boolean] True if the session should be refreshed, false otherwise.
    def refresh_session?
      return true unless @current_session

      Time.at(@current_session.response.expires_at) < Time.now
    end

    # Refreshes the current session if it has expired.
    # @return [Session]
    def refresh_session!
      @current_sesion = @current_session.refresh!
    end

    # Uploads a file to ChatKit and returns the file ID.
    # @param file [File] The file to be uploaded.
    #
    # @raise [RuntimeError] If the file type is invalid.
    # @return [String] The ID of the uploaded file.
    def upload_file!(file:, client_secret:)
      raise "Invalid file type" unless file.is_a?(File)

      response = Files.upload!(
        client_secret:,
        file:,
        client: self
      )

      response.id
    end
  end
end

# Ruby ChatKit

A Ruby client library for [OpenAI's ChatKit API](https://platform.openai.com/docs/api-reference/chatkit), providing easy-to-use interfaces for creating sessions, sending messages, and uploading files.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
  - [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Sending Messages with File Attachments](#sending-messages-with-file-attachments)
  - [Advanced Session Configuration](#advanced-session-configuration)
  - [Manual Session and Conversation Management](#manual-session-and-conversation-management)
  - [File Upload](#file-upload)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)

## Features

- 🔐 Session management with automatic refresh
- 💬 Send text messages to ChatKit conversations
- 📎 File upload support with message attachments
- 🔄 Streaming response parsing
- ⚡ Built-in error handling

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-chatkit'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install ruby-chatkit
```

## Usage

### Configuration

Configure the gem with your OpenAI API key:

```ruby
ChatKit.configure do |config|
  config.api_key = "sk-proj-your-api-key-here"
end
```

You can also set the API key using an environment variable:

```bash
export OPENAI_API_KEY="sk-proj-your-api-key-here"
```

### Quick Start

```ruby
# Initialize the client
client = ChatKit::Client.new

# Create a session
client.create_session!(
  user_id: "user_123",
  workflow_id: "wf_your_workflow_id"
)

# Send a message
response = client.send_message!(text: "Hello, how are you?")
puts response.text
```

### Sending Messages with File Attachments

```ruby
# Open a file
file = File.open("/path/to/your/image.png")

# Send message with attachment
response = client.send_message!(
  text: "Could you describe this image?",
  files: [file]
)

puts response.text
```

### Advanced Session Configuration

You can customize session behavior with additional configuration options:

```ruby
client.create_session!(
  user_id: "user_123",
  workflow_id: "wf_your_workflow_id",
  chatkit_configuration: {
    # Chat history retention
    history: {
      enabled: true,           # Enable conversation history (default: true)
      recent_threads: 10       # Number of recent threads to keep (default: nil - unlimited)
    },
    # File upload settings
    file_upload: {
      enabled: true,           # Allow file uploads (default: false)
      max_file_size: 512,      # Maximum file size in MB (default: 512)
      max_files: 10            # Maximum number of files per message (default: 10)
    },
    # Automatic thread titling
    automatic_thread_titling: {
      enabled: true            # Auto-generate thread titles (default: true)
    }
  },
  # Session expiration
  expires_after: {
    anchor: "creation",        # Base timestamp: "creation" or "last_activity"
    seconds: 3600              # Session lifetime in seconds (default: 600 - 10 minutes)
  },
  # Rate limiting
  rate_limits: {
    max_requests_per_1_minute: 100  # Max requests per minute (default: 10)
  }
)
```

**Configuration Options:**

- [history](https://platform.openai.com/docs/api-reference/chatkit/sessions/create#chatkit_sessions_create-chatkit_configuration-history): Controls conversation history retention

  - `enabled`: Whether to retain chat history (default: `true`)
  - `recent_threads`: Limit the number of recent threads kept (default: `nil` - unlimited)

- [file_upload](https://platform.openai.com/docs/api-reference/chatkit/sessions/create#chatkit_sessions_create-chatkit_configuration-file_upload): Controls file upload capabilities

  - `enabled`: Allow file uploads in conversations (default: `false`)
  - `max_file_size`: Maximum file size in MB (default: `512`)
  - `max_files`: Maximum number of files per message (default: `10`)

- [automatic_thread_titling](https://platform.openai.com/docs/api-reference/chatkit/sessions/create#chatkit_sessions_create-chatkit_configuration-automatic_thread_titling): Automatically generate descriptive thread titles

  - `enabled`: Enable auto-titling (default: `true`)

- [expires_after](https://platform.openai.com/docs/api-reference/chatkit/sessions/create#chatkit_sessions_create-expires_after): Session expiration settings

  - `anchor`: Base timestamp - `"creation"` (session created) or `"last_activity"` (last request)
  - `seconds`: Time in seconds until session expires (default: `600` - 10 minutes)

- [rate_limits](https://platform.openai.com/docs/api-reference/chatkit/sessions/create#chatkit_sessions_create-rate_limits): Request rate limiting
  - `max_requests_per_1_minute`: Maximum API requests per minute (default: `10`)

### Manual Session and Conversation Management

For more control, you can use the underlying classes directly:

```ruby
# Create a session manually
session = ChatKit::Session.create!(
  user_id: "user_123",
  workflow: { id: "wf_your_workflow_id" },
  client: client
)

# Send a conversation message
conversation = ChatKit::Conversation.send_message!(
  client_secret: session.response.client_secret,
  text: "Hello!",
  client: client
)

# Access the response
answer = conversation.response.answer
puts answer.text
```

### File Upload

Upload files to ChatKit:

```ruby
file = File.open("/path/to/document.pdf")

response = ChatKit::Files.upload!(
  client_secret: session.response.client_secret,
  file: file,
  client: client
)

puts response.id
puts response.name
puts response.mime_type
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/saleszera/ruby-chatkit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/ruby-chatkit/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruby::Chatkit project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ruby-chatkit/blob/main/CODE_OF_CONDUCT.md).

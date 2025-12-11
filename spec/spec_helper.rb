# frozen_string_literal: true

require "dotenv/load"
Dotenv.load(".env.test") if File.exist?(".env.test")
require "chatkit"
require "shoulda-matchers"
require "factory_bot"
require "webmock/rspec"

# Configure WebMock
WebMock.disable_net_connect!(allow_localhost: true)

# Load support files (helpers, shared contexts)
Dir[File.join(__dir__, "support/**/*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Configure FactoryBot
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Allow message expectations on nil
  config.mock_with :rspec do |mocks|
    mocks.allow_message_expectations_on_nil = true
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
  end
end

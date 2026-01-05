# frozen_string_literal: true

FactoryBot.define do
  factory :config, class: "ChatKit::Config" do
    api_key { "test_api_key_456" }
    host { "https://test-config.openai.com" }
    timeout { nil }

    trait :with_nil_api_key do
      api_key { nil }
    end

    trait :with_empty_api_key do
      api_key { "" }
    end

    trait :with_production_host do
      host { ChatKit::Client::OpenAI::HOST }
    end

    trait :with_custom_host do
      host { "https://custom-config.example.com" }
    end

    trait :with_localhost do
      host { "http://localhost:3000" }
    end

    trait :production_config do
      api_key { "sk-prod123456789" }
      host { ChatKit::Client::OpenAI::HOST }
    end

    trait :development_config do
      api_key { "dev_key_123" }
      host { "http://localhost:8000" }
    end

    initialize_with { new(api_key:, host:, timeout:) }
  end
end

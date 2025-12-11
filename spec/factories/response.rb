# frozen_string_literal: true

FactoryBot.define do
  factory :base_response, class: "ChatKit::Session::BaseResponse" do
    id { "sess_abc123" }
    object { "chatkit.session" }
    status { "active" }
    association :chatkit_configuration
    client_secret { "secret_xyz789" }
    expires_at { (Time.now + 3600).to_i.to_s }
    max_requests_per_1_minute { 10 }
    association :rate_limits
    user { { "id" => "user_123", "name" => "John Doe" } }
    association :workflow

    trait :expired do
      status { "expired" }
      expires_at { (Time.now - 3600).to_i.to_s }
    end

    trait :with_nil_user do
      user { nil }
    end

    trait :with_empty_user do
      user { {} }
    end

    trait :high_rate_limit do
      max_requests_per_1_minute { 100 }
    end

    trait :low_rate_limit do
      max_requests_per_1_minute { 1 }
    end

    initialize_with do
      new(
        id:,
        object:,
        status:,
        chatkit_configuration:,
        client_secret:,
        expires_at:,
        max_requests_per_1_minute:,
        rate_limits:,
        user:,
        workflow:
      )
    end
  end
end

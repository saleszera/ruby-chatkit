# frozen_string_literal: true

FactoryBot.define do
  factory :automatic_thread_titling, class: "ChatKit::Session::ChatKitConfiguration::AutomaticThreadTitling" do
    enabled { true }

    trait :enabled do
      enabled { true }
    end

    trait :disabled do
      enabled { false }
    end

    trait :nil_enabled do
      enabled { nil }
    end

    trait :default_enabled do
      enabled { ChatKit::Session::Defaults::ENABLED }
    end

    initialize_with { new(enabled:) }
  end

  factory :file_upload, class: "ChatKit::Session::ChatKitConfiguration::FileUpload" do
    enabled { true }
    max_file_size { 256 }
    max_files { 5 }

    trait :enabled do
      enabled { true }
    end

    trait :disabled do
      enabled { false }
    end

    trait :nil_enabled do
      enabled { nil }
    end

    trait :default_enabled do
      enabled { ChatKit::Session::Defaults::ENABLED }
    end

    trait :large_files do
      max_file_size { 1024 }
      max_files { 20 }
    end

    trait :small_files do
      max_file_size { 64 }
      max_files { 2 }
    end

    trait :default_limits do
      max_file_size { ChatKit::Session::ChatKitConfiguration::FileUpload::Defaults::MAX_FILE_SIZE }
      max_files { ChatKit::Session::ChatKitConfiguration::FileUpload::Defaults::MAX_FILES }
    end

    trait :nil_limits do
      max_file_size { nil }
      max_files { nil }
    end

    initialize_with { new(enabled:, max_file_size:, max_files:) }
  end

  factory :history, class: "ChatKit::Session::ChatKitConfiguration::History" do
    enabled { true }
    recent_threads { 50 }

    trait :enabled do
      enabled { true }
    end

    trait :disabled do
      enabled { false }
    end

    trait :nil_enabled do
      enabled { nil }
    end

    trait :default_enabled do
      enabled { ChatKit::Session::Defaults::ENABLED }
    end

    trait :no_thread_limit do
      recent_threads { nil }
    end

    trait :limited_threads do
      recent_threads { 10 }
    end

    trait :unlimited_threads do
      recent_threads { 1000 }
    end

    trait :default_recent_threads do
      recent_threads { nil }
    end

    initialize_with { new(enabled:, recent_threads:) }
  end

  factory :chatkit_configuration, class: "ChatKit::Session::ChatKitConfiguration" do
    transient do
      automatic_thread_titling_params { { enabled: true } }
      file_upload_params { { enabled: true, max_file_size: 256, max_files: 5 } }
      history_params { { enabled: true, recent_threads: 50 } }
    end

    trait :all_enabled do
      automatic_thread_titling_params { { enabled: true } }
      file_upload_params { { enabled: true, max_file_size: 512, max_files: 10 } }
      history_params { { enabled: true, recent_threads: 100 } }
    end

    trait :all_disabled do
      automatic_thread_titling_params { { enabled: false } }
      file_upload_params { { enabled: false, max_file_size: 256, max_files: 5 } }
      history_params { { enabled: false, recent_threads: 25 } }
    end

    trait :mixed_settings do
      automatic_thread_titling_params { { enabled: true } }
      file_upload_params { { enabled: false, max_file_size: 128, max_files: 3 } }
      history_params { { enabled: true, recent_threads: nil } }
    end

    trait :minimal_config do
      automatic_thread_titling_params { { enabled: nil } }
      file_upload_params { { enabled: nil, max_file_size: nil, max_files: nil } }
      history_params { { enabled: nil, recent_threads: nil } }
    end

    trait :with_objects do
      automatic_thread_titling_params { build(:automatic_thread_titling) }
      file_upload_params { build(:file_upload) }
      history_params { build(:history) }
    end

    initialize_with do
      new(
        file_upload: file_upload_params,
        history: history_params,
        automatic_thread_titling: automatic_thread_titling_params
      )
    end
  end
end

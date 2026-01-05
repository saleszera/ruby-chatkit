# frozen_string_literal: true

module FixtureHelper
  # Load fixture file from spec/fixtures.
  # Usage: load_fixture("session/create/success.json") or
  #        load_fixture("success.json", subdir: "session/create")
  def load_fixture(filename, subdir: nil)
    subdir_path = subdir ? File.join("spec", "fixtures", subdir, filename) : File.join("spec", "fixtures", filename)

    path = if defined?(Rails) && Rails.respond_to?(:root)
             Rails.root.join(subdir_path)
           else
             File.expand_path(File.join(__dir__, "..",
               subdir ? File.join("fixtures", subdir, filename) : File.join("fixtures", filename)))
           end

    File.read(path)
  end
end

RSpec.configure do |config|
  config.include FixtureHelper
end

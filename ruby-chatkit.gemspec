# frozen_string_literal: true

require_relative "lib/chatkit/version"

Gem::Specification.new do |spec|
  spec.name = "ruby-chatkit"
  spec.version = ChatKit::VERSION
  spec.authors = ["Raniery"]
  spec.email = ["raniery@saleszera.com"]

  spec.summary = "Ruby client library for OpenAI's ChatKit API"
  spec.description = "A Ruby abstraction of OpenAI's ChatKit JavaScript library, providing easy-to-use interfaces for creating sessions, sending messages, and uploading files to ChatKit conversations."
  spec.homepage = "https://github.com/saleszera/ruby-chatkit"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/saleszera/ruby-chatkit"
  spec.metadata["changelog_uri"] = "https://github.com/saleszera/ruby-chatkit/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "base64"
  spec.add_dependency "event_stream_parser"
  spec.add_dependency "http"
  spec.add_dependency "zeitwerk"
  spec.add_dependency "openssl"
  spec.add_dependency "logger"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

# frozen_string_literal: true

require_relative "lib/sfn_job/version"

Gem::Specification.new do |spec|
  spec.name = "sfn_job"
  spec.version = SfnJob::VERSION
  spec.authors = ["Shia"]
  spec.email = ["rise.shia@gmail.com"]

  spec.summary = "ActiveJob on State Functions"
  spec.description = "ActiveJob on State Functions"
  spec.homepage = "https://github.com/riseshia/sfn_job"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/riseshia/sfn_job"
  spec.metadata["changelog_uri"] = "https://github.com/riseshia/sfn_job"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ spec/ .git .github Gemfile])
    end
  end
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-states"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

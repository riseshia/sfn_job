# frozen_string_literal: true

require "sfn_job"

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../sample/config/environment', __dir__)
require 'rspec/rails'

Dir[Rails.root.join("../spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around do |e|
    begin
      original_env = ENV.to_h.dup
      e.run
    ensure
      ENV.replace(original_env)
    end
  end

  config.before(:suite) do
    Rails.application.load_tasks
  end

  config.before(:each) do
    Rake.application.tasks.each(&:reenable)
  end

  config.include(CustomMatchers)
end

# frozen_string_literal: true

namespace :sfn_job do
  desc 'Start worker to execute jobs'
  task execute: :environment do
    require 'sfn_job'

    $stdout.sync = true

    if ENV['SERIALIZED_JOB'].nil?
      raise 'SERIALIZED_JOB environment variable is required'
    end

    serialized_job = ENV.fetch('SERIALIZED_JOB')

    SfnJob::Runner.run(serialized_job)
  end
end

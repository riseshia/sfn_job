# frozen_string_literal: true

namespace :sfn_job do
  desc 'Start worker to execute jobs'
  task execute: :environment do
    require 'sfn_job'

    $stdout.sync = true

    SfnJob::Runner.run(
      serialized_job: ARGV[1],
    )
  end
end

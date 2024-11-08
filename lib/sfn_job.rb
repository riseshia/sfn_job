# frozen_string_literal: true

require "json"
require "aws-sdk-states"

require_relative "sfn_job/version"
require_relative "sfn_job/configuration"
require_relative "sfn_job/runner"

module SfnJob
  class << self
    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end

    def enqueue(job)
      sfn_client.start_execution({
        state_machine_arn: config.state_machine_arn,
        name: job.job_id,
        input: serialize(job),
      })
    end

    def sfn_client
      @sfn_client ||= Aws::States::Client.new(region: config.region)
    end

    private def serialize(job)
      JSON.dump({
        job_class: job.class.name,
        job_id: job.job_id,
        serialized_arguments: job.serialize,
      })
    end

    private def deserialize(serialized_job)
      JSON.parse(serialized_job).transform_keys(&:to_sym)
    end
  end
end

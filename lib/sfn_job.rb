# frozen_string_literal: true

require "json"
require "aws-sdk-states"

begin
  require "rails"
rescue LoadError
else
  require "sfn_job/railtie"
end

require_relative "sfn_job/version"
require_relative "sfn_job/configuration"
require_relative "sfn_job/runner"

module SfnJob
  MAX_SERIALIZED_JOB_SIZE = 60_000

  class << self
    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end

    def enqueue(job)
      sfn_client.start_execution({
        state_machine_arn: job.queue_name,
        name: "#{job.class.name}-#{job.job_id}",
        input: serialize(job),
      })
    end

    def sfn_client
      @sfn_client ||= Aws::States::Client.new(region: config.region, stub_responses: config.stub_sfn_client)
    end

    private def serialize(job)
      JSON.dump({ serialized_job: JSON.dump(job.serialize) }).tap do |serialized_job|
        raise "Job serialization is too large" if serialized_job.bytesize > MAX_SERIALIZED_JOB_SIZE
      end
    end

    def deserialize(serialized_job)
      JSON.parse(serialized_job)
    end
  end
end

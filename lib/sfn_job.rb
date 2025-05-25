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
      normalized_name = normalize_namespace(job.class.name)
      sfn_client.start_execution({
        state_machine_arn: build_arn(job.queue_name),
        name: "#{normalized_name}-#{job.job_id}",
        input: serialize(job),
      })
    end

    def sfn_client
      @sfn_client ||= Aws::States::Client.new(region: config.region, stub_responses: config.stub_sfn_client)
    end

    private def build_arn(sfn_name)
      "arn:aws:states:#{config.region}:#{config.account_id}:stateMachine:#{sfn_name}"
    end

    private def serialize(job)
      JSON.dump({ serialized_job: JSON.dump(job.serialize) }).tap do |serialized_job|
        raise "Job serialization is too large" if serialized_job.bytesize > MAX_SERIALIZED_JOB_SIZE
      end
    end

    private def normalize_namespace(name)
      name.to_s.gsub("::", "_")
    end

    def deserialize(serialized_job)
      JSON.parse(serialized_job)
    end
  end
end

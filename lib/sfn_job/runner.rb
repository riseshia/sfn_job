# frozen_string_literal: true

module SfnJob
  class Runner
    class << self
      def run(serialized_job)
        job_data = SfnJob.deserialize(serialized_job)

        worker = job_data[:class].constantize.new

        worker.perform(*job_data[:args], **job_data[:kwargs])
      end
    end
  end
end

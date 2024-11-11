# frozen_string_literal: true

module SfnJob
  class Runner
    class << self
      def run(serialized_job)
        job_data = SfnJob.deserialize(serialized_job)
        ActiveJob::Base.execute job_data
      end
    end
  end
end

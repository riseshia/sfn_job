# frozen_string_literal: true

module ActiveJob
  module QueueAdapters
    class SfnJobAdapter
      def enqueue(job)
        SfnJob.enqueue(job)
      end

      def enqueue_at(job, timestamp)
        raise NotImplementedError, "enqueue_at is not supported by SfnJob"
      end

      def enqueue_all(jobs)
        raise NotImplementedError, "enqueue_all is not supported by SfnJob"
      end
    end
  end
end

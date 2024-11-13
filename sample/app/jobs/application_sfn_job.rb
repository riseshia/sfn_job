class ApplicationSfnJob < ApplicationJob
  self.queue_adapter = :sfn_job
  queue_as "sfn_job"
end

class ApplicationSfnJob < ApplicationJob
  self.queue_adapter = :sfn_job
  queue_as "arn:aws:states:ap-northeast-1:123456789012:stateMachine:sfn_job"
end

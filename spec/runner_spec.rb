# frozen_string_literal: true

module SfnJob
  RSpec.describe Runner do
    let(:job_data) do
      {
        "job_class" => "TestJob",
        "job_id" => "44074b96-8190-49a2-b112-2d9ac8117d02",
        "provider_job_id" => nil,
        "queue_name" => "arn:aws:states:ap-northeast-1:123456789012:stateMachine:sfn_job",
        "priority" => nil,
        "arguments" => [
          "a",
          "b",
          {
            "c" => "c",
            "d" => "d",
            "_aj_ruby2_keywords" => %w[c d]
          }
        ],
        "executions" => 0,
        "exception_executions" => {},
        "locale" => "en",
        "timezone" => "UTC",
        "enqueued_at" => "2024-11-11T03:26:45.564533000Z",
        "scheduled_at" => nil,
      }
    end

    let(:serialized_job) do
      JSON.dump(job_data)
    end

    it "runs TestJob" do
      job = TestJob.new

      expect(TestJob).to receive(:new).and_return(job)
      expect(job).to receive(:perform).with("a", "b", c: "c", d: "d")

      Runner.run(serialized_job)
    end
  end
end

# frozen_string_literal: true

RSpec.describe 'sfn_job:execute' do
  subject(:task) { Rake.application['sfn_job:execute'] }

  context 'when SERIALIZED_JOB is set' do
    let(:job_data) do
      {
        "job_class" => "TestJob",
        "arguments" => ["arg1", "arg2", { "key" => "value" }],
      }
    end
    let(:serialized_job) { JSON.dump(job_data) }

    before do
      ENV['SERIALIZED_JOB'] = serialized_job
    end

    it 'calls runner with the serialized job' do
      expect(ActiveJob::Base).to receive(:execute).with(job_data)

      task.invoke
    end
  end

  context 'when SERIALIZED_JOB is not set' do
    before do
      ENV.delete('SERIALIZED_JOB')
    end

    it 'raises error with appropriate message' do
      expect(SfnJob::Runner).not_to receive(:run)

      expect { task.invoke }.to raise_error(RuntimeError, 'SERIALIZED_JOB environment variable is required')
    end
  end

  context 'when SERIALIZED_JOB is invalided serialized string' do
    before do
      ENV['SERIALIZED_JOB'] = '{"hoge":}'
    end

    it 'raises error' do
      expect { task.invoke }.to raise_error(JSON::ParserError)
    end
  end
end

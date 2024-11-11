RSpec.describe 'sfn_job:execute' do
  subject(:task) { Rake.application['sfn_job:execute'] }

  context 'when SERIALIZED_JOB is set' do
    it 'calls runner' do
      ENV['SERIALIZED_JOB'] = '{}'
      expect(SfnJob::Runner).to receive(:run).with(serialized_job: '{}')

      task.invoke
    end
  end

  context 'when SERIALIZED_JOB is not set' do
    it 'raises error' do
      expect(SfnJob::Runner).not_to receive(:run)

      expect { task.invoke }.to raise_error(RuntimeError, 'SERIALIZED_JOB environment variable is required')
    end
  end
end

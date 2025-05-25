RSpec.describe Ns::TestJob do
  describe '.perform_later' do
    let(:sfn_client) { SfnJob.sfn_client }
    let(:queue_name) { 'arn:aws:states:ap-northeast-1:123456789012:stateMachine:sfn_job' }

    it 'calls start_execution' do
      expect(sfn_client).to receive(:start_execution).with(any_args) do |params|
        expect(params[:state_machine_arn]).to eq(queue_name)
        expect(params[:name]).to be_valid_state_execution_name(Ns::TestJob)
      end
      Ns::TestJob.perform_later
    end
  end

  describe '.perform_now' do
    let(:sfn_client) { SfnJob.sfn_client }
    let(:queue_name) { 'arn:aws:states:ap-northeast-1:123456789012:stateMachine:sfn_job' }

    it 'calls start_execution' do
      expect(sfn_client).to receive(:start_execution).with(any_args) do |params|
        expect(params[:state_machine_arn]).to eq(queue_name)
        expect(params[:name]).to be_valid_state_execution_name(Ns::TestJob)
      end
      Ns::TestJob.perform_later("a", "b", c: "c", d: "d")
    end
  end
end

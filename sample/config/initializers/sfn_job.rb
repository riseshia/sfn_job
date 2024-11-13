SfnJob.configure do |config|
  config.region = "ap-northeast-1"
  config.account_id = "123456789012"
  config.stub_sfn_client = true
end

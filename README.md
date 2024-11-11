# SfnJob

SfnJob provides a simple way to run a job on AWS Step Functions.

This might be useful when your team use sidekiq on container
which makes it hard to run a job takes long time.

## Installation

```
gem install sfn_job
# or bundle add sfn_job
```

## Configuration

```ruby
SfnJob.configure do |config|
  config.region = 'ap-northeast-1'
  config.stub_sfn_client = Rails.env.test? # Set this to true when test not to call AWS API actually
end
```

## Usage

this gem provides active job adapter and runner task for enqueued job

```ruby
class SomeJob < ApplicationJob
  self.queue_adapter = :sfn_job
  # Treat state machine arn as queue name
  queue_as "arn:aws:states:ap-northeast-1:123456789012:stateMachine:sfn_job"

  def perform(item_id)
    # do something
  end
end
```

The gem will call StartExecution API with input as below:

```json
{
  "serialized_job": "serialized_job_as_json"
}
```

And create state machine which pass this serialized_job to RunTask overrided env "SERIEALIZED_JOB".

```bash
SERIEALIZED_JOB='serialized_job_as_json' bundle exec rails sfn_job:execute
```

## Why

It's quite complex to handle long time async job,
such as [sidekiq-iteration](https://github.com/fatkodima/sidekiq-iteration) or split job into small pieces with `Sideiq::Batch`.

## Why not

- hard to accept more infra complexity
- which jobs are enqueued frequently
  - Be careful with sfn StartExecution api rate limit. [Step Functions service quotas - AWS](https://docs.aws.amazon.com/step-functions/latest/dg/service-quotas.html)
  - And RunTask api rate limit also (if you use Fargate) [AWS Fargate throttling quotas - AWS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/throttling.html)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/riseshia/sfn_job.

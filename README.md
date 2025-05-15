# ActiveJob::GoogleCloudTasks::HTTP

ActiveJob::GoogleCloudTasks::HTTP is an ActiveJob adapter for running jobs via Google Cloud Tasks. As the name suggests it only supports HTTP targets.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activejob-google_cloud_tasks-http'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activejob-google_cloud_tasks-http

## Usage

### Setup

Configure an adapter instance and pass it to Active Job:

```ruby
Rails.application.config.active_job.queue_adapter = ActiveJob::GoogleCloudTasks::HTTP::Adapter.new(
  project: 'a-gcp-project-name',
  location: 'asia-northeast1',
  url: 'https://hibariya.org/',
  client: Google::Cloud::Tasks.cloud_tasks, # optional
  task_options: { # optional
    oidc_token: {
      service_account_email: 'cloudrun-invoker@a-gcp-project-name.iam.gserviceaccount.com'
    }
  }
)
```

A name passed to `queue_as` will be used to identify which Cloud Tasks queue will be used by the job:

```ruby
class GoodJob < ApplicationJob
  queue_as :a_queue_name

  # ...
end
```

Mount the Rack application to set up an endpoint for performing jobs:

```ruby
# in config/routes.rb
mount ActiveJob::GoogleCloudTasks::HTTP::Rack.new, at: '/_jobs'
```

Note that this rack app itself does not have any authentication mechanism.

### Testing

Requiring `active_job/google_cloud_tasks/http/inline` makes the adapter skip enqueueing jobs to Google Cloud Tasks. Once a job is enqueued, it will perform the job immediately.

```ruby
require 'active_job/google_cloud_tasks/http/inline' unless Rails.env.production?
```

#### Error when calling assets:precompile?

When you call assets:precompile, all configs and initializers are loaded. If you load your credentials via environment variables they may not be available and the adapter initialization will cause errors. To solve this, wrap the `queue_adapter` config in a `unless ARGV.include?("assets:precompile")` condition. e.g.:

```ruby
unless ARGV.include?("assets:precompile") # prevents running on assets:precompile
  Rails.application.config.active_job.queue_adapter = ActiveJob::GoogleCloudTasks::HTTP::Adapter.new(
    project: 'my-project',
    location: 'europe-west2',
    url: 'https://www.example.com/jobs',
    client: Google::Cloud::Tasks.cloud_tasks { |config|
      # this will cause an error if the environment variable does not exist
      config.credentials = JSON.parse(ENV["GOOGLE_CLOUD_PRODUCTION_KEYFILE"])
    }
  )
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/esminc/activejob-google_cloud_tasks-http.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveJob::GoogleCloudTasks::HTTP project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/esminc/activejob-google_cloud_tasks-http/blob/master/CODE_OF_CONDUCT.md).

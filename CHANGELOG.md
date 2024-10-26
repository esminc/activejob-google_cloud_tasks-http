## 0.3.0

- [Support for enqueue_after_transaction_commit setting introduced in Rails 7.2](https://github.com/esminc/activejob-google_cloud_tasks-http/pull/14) by @bluerabbit
- [Update readme example to use new config format](https://github.com/esminc/activejob-google_cloud_tasks-http/pull/14) by @jaredlt

## 0.2.0

This version depends on google-cloud-tasks 2.0 or later. Since google-cloud-tasks 2.0 has API changes, upgrading to this version may affect to existing adapter initialization code. If you are initializing Google::Cloud::Tasks client manually, you will have to change `Google::Cloud::Tasks.new` to `Google::Cloud::Tasks.cloud_tasks` as follows:

from:

    Rails.application.config.active_job.queue_adapter = ActiveJob::GoogleCloudTasks::HTTP::Adapter.new(
      client: Google::Cloud::Tasks.new(version: :v2beta3),
      # ...
    )

to:

    Rails.application.config.active_job.queue_adapter = ActiveJob::GoogleCloudTasks::HTTP::Adapter.new(
      client: Google::Cloud::Tasks.cloud_tasks(version: :v2beta3),
      # ...
    )

For more information, see this migration guide: https://github.com/googleapis/google-cloud-ruby/blob/master/google-cloud-tasks/MIGRATING.md

## 0.1.0

:tada:

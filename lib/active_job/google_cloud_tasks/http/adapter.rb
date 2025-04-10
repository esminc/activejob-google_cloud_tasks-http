require 'json'
require 'google/cloud/tasks'
require 'gapic/grpc' # to use Google::Protobuf::Timestamp which is used by Google::Cloud::Tasks::Vxx

module ActiveJob
  module GoogleCloudTasks
    module HTTP
      class Adapter
        def initialize(project:, location:, url:, task_options: {}, client: nil, enqueue_after_transaction_commit: false)
          @project = project
          @location = location
          @url = url
          @task_options = task_options
          @client = client
          @enqueue_after_transaction_commit = enqueue_after_transaction_commit
        end

        # Method expected in Rails 7.2 and later
        def enqueue_after_transaction_commit?
          @enqueue_after_transaction_commit
        end

        def enqueue(job, attributes = {})
          path = client.queue_path(project: @project, location: @location, queue: job.queue_name)
          task = build_task(job, attributes)

          client.create_task parent: path, task: task
        end

        def enqueue_at(job, scheduled_at)
          enqueue job, scheduled_at: scheduled_at
        end

        private

        def client
          @client ||= Google::Cloud::Tasks.cloud_tasks
        end

        def build_task(job, attributes)
          task = {
            http_request: {
              http_method: :POST,
              url: @url,
              headers: {'Content-Type' => 'application/json'},
              body: JSON.dump(job: job.serialize).force_encoding(Encoding::ASCII_8BIT),
              **@task_options
            }
          }

          task[:schedule_time] = Google::Protobuf::Timestamp.new(seconds: attributes[:scheduled_at].to_i) if attributes.has_key?(:scheduled_at)

          task
        end
      end
    end
  end
end


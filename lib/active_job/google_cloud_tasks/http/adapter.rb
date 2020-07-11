require 'json'
require 'google/cloud/tasks'
require 'gapic/protobuf'

module ActiveJob
  module GoogleCloudTasks
    module HTTP
      class Adapter
        def initialize(project:, location:, url:, task_options: {}, client: nil)
          @project = project
          @location = location
          @url = url
          @task_options = task_options
          @client = client
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
          @client ||= Google::Cloud::Tasks.cloud_tasks(version: :v2beta3)
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

          task[:schedule_time] = Gapic::Protobuf.time_to_timestamp(Time.at(attributes[:scheduled_at].to_i)) if attributes.has_key?(:scheduled_at)

          task
        end
      end
    end
  end
end


require 'active_job/google_cloud_tasks/http/adapter'

module ActiveJob
  module GoogleCloudTasks
    module HTTP
      module Inlining
        # Method expected in Rails 7.2 and later
        def enqueue_after_transaction_commit?
          false
        end

        def enqueue(job, *)
          ActiveJob::Base.execute job.serialize
        end

        alias enqueue_at enqueue
      end

      Adapter.prepend Inlining
    end
  end
end

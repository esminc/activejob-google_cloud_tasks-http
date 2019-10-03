require 'active_job/google_cloud_tasks/http/adapter'

module ActiveJob
  module GoogleCloudTasks
    module HTTP
      module Inlining
        def enqueue(job, *)
          ActiveJob::Base.execute job.serialize
        end

        alias enqueue_at enqueue
      end

      Adapter.prepend Inlining
    end
  end
end

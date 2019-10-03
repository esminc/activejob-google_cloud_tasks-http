module ActiveJob
  module GoogleCloudTasks
    module HTTP
      autoload :Adapter, 'active_job/google_cloud_tasks/http/adapter'
      autoload :Rack,    'active_job/google_cloud_tasks/http/rack'
      autoload :VERSION, 'active_job/google_cloud_tasks/http/version'
    end
  end
end

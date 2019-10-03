require 'json'
require 'rack'

module ActiveJob
  module GoogleCloudTasks
    module HTTP
      class Rack
        class PayloadError < StandardError; end

        def call(env)
          request = ::Rack::Request.new(env)
          payload = extract_payload(request)

          ActiveJob::Base.execute payload

          [200, {}, ['ok']]
        rescue PayloadError => e
          [400, {}, [e.cause.message]]
        rescue => e
          [500, {}, [e.message]]
        end

        private

        def extract_payload(request)
          JSON.parse(request.body.read).fetch('job')
        rescue JSON::ParserError, KeyError
          raise PayloadError
        end
      end
    end
  end
end

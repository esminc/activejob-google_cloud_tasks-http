require 'logger'
require 'active_job'
require 'stringio'

RSpec.describe ActiveJob::GoogleCloudTasks::HTTP do
  it "has a version number" do
    expect(ActiveJob::GoogleCloudTasks::HTTP::VERSION).not_to be nil
  end

  describe ActiveJob::GoogleCloudTasks::HTTP::Rack do
    let(:app) { ActiveJob::GoogleCloudTasks::HTTP::Rack.new }
    let(:request_body) { StringIO.new(JSON.dump(job: serialized_job)) }
    let(:env) { {'REQUEST_METHOD' => 'POST', 'rack.input' => request_body} }

    subject(:response) { app.call(env) }

    context 'with valid request body' do
      let(:serialized_job) { {'job_class' => 'DailyJob'} }

      it 'executes the job' do
        expect(ActiveJob::Base).to receive(:execute).with(serialized_job)

        expect(response[0]).to eq 200
      end
    end

    context 'without request body' do
      let(:env) { {'REQUEST_METHOD' => 'POST', 'rack.input' => StringIO.new} }

      it do
        expect(ActiveJob::Base).not_to receive(:execute)

        expect(response[0]).to eq 400
      end
    end

    context 'with malformed json' do
      let(:request_body) { StringIO.new('cloud cukoo land') }

      it do
        expect(response[0]).to eq 400
      end
    end

    context 'with malformed job' do
      let(:serialized_job) { {'cloud' => 'cuckoo land'} }

      it do
        expect(response[0]).not_to eq 200
      end
    end
  end

  describe ActiveJob::GoogleCloudTasks::HTTP::Adapter do
    class DailyJob < ActiveJob::Base
      queue_as 'queue_name'

      def perform(*args)
      end
    end

    it 'works' do
      job = DailyJob.new
      scheduled_at = 0
      client = double('Google::Cloud::Tasks')
      allow(client).to receive(:queue_path)
      adapter = ActiveJob::GoogleCloudTasks::HTTP::Adapter.new(
        project: 'apollo',
        location: 'asia-northeast1',
        url: 'https://example.com/_jobs',
        client: client
      )

      expect(client).to receive(:create_task) do |args|
        expect(args[:task][:schedule_time]).to eq (Google::Protobuf::Timestamp.new(seconds: scheduled_at))
      end

      adapter.enqueue_at job, scheduled_at
    end
  end
end

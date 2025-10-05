require "rails_helper"

RSpec.describe LogEntryCreationJob, type: :job do
  include ActiveJob::TestHelper

  let(:params) do
    { user_id: 1, event_id: 1, action: :event_member_created, metadata: { key: "value" } }
  end
  subject(:job) { described_class.perform_later(**params) }

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(**params)
  end

  it 'create a LogEntry' do
    expect { perform_enqueued_jobs { job } }.to change(LogEntry, :count).by(1)
  end
end

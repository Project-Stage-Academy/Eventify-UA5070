require "rails_helper"

RSpec.describe LogEntryCreationJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(user_id: user_id, event_id: event_id, action: action, metadata: metadata) }

  let(:user_id) { 1 }
  let(:event_id) { 1 }
  let(:action) { :event_member_created }
  let(:metadata) { { key: "value" } }

  before do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(user_id: user_id, event_id: event_id, action: action, metadata: metadata)
  end

  it 'saves a LogEntry with correct attributes' do
    expect { perform_enqueued_jobs { job } }.to change(LogEntry, :count).by(1)

    log_entry = LogEntry.last
    expect(log_entry).not_to be_nil
    expect(log_entry.user_id).to eq(user_id)
    expect(log_entry.event_id).to eq(event_id)
    expect(log_entry.action).to eq(action.to_s)
    expect(log_entry.metadata).to eq(metadata.stringify_keys)
  end
end

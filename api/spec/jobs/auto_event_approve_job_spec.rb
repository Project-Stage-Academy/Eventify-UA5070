require 'rails_helper'

RSpec.describe AutoEventApproveJob, type: :job do
  include ActiveJob::TestHelper

  let(:status) { :draft_on_review }
  let(:event) { create(:event, status: status) }

  describe "::after_delay" do
    let(:mock_job_id) { 12345 }

    before { allow_any_instance_of(ActiveJob::Base).to receive(:provider_job_id).and_return(mock_job_id) }

    subject(:job) { described_class.after_delay(event) }

    it "schedules the job with a delay" do
      expect { job }.to have_enqueued_job(described_class)
        .with(event.id)
        .at(be_within(1.second).of(AutoEventApproveJob::DELAY.from_now))
    end

    it "saves the approve_job_id to the event" do
      job
      expect(event.reload.approve_job_id).to eq(mock_job_id)
    end
  end

  describe "#perform" do
    subject(:job) { described_class.perform_later(event.id) }

    it 'queues the job' do
      expect { job }.to have_enqueued_job(described_class)
        .with(event.id)
    end

    context "when event can be approved" do
      it "approves the event" do
        expect {
          perform_enqueued_jobs { job }
        }.to change { event.reload.status.to_sym }
          .from(status)
          .to(EventStatusService.new(event).status_on_auto_approve)
      end
    end

    context "when event has invalid status for approval" do
      before { event.update(status: :cancelled) }

      it "does not change status" do
        expect {
          perform_enqueued_jobs { job }
        }.not_to change { event.reload.status }
      end
    end
  end
end

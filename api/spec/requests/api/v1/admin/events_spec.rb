require "rails_helper"

RSpec.describe "Admin Events API", type: :request do
  let!(:admin_role) { Role.create!(name: "admin") }
  let!(:user_role)  { Role.create!(name: "user") }

  let(:admin) { create(:user, :admin) }
  let(:user)  { create(:user) }
  let!(:event) { create(:event, status: :draft_on_review) }

  let(:admin_headers) { auth_headers_for(admin) }
  let(:user_headers)  { auth_headers_for(user) }
  let(:body) { JSON.parse(response.body) }

  describe "GET /api/v1/admin/events" do
    context "as admin" do
      it "returns all events with member counts" do
        get api_v1_admin_events_path, headers: admin_headers

        expect(response).to have_http_status(:ok)
        expect(body["data"]).to be_an(Array)
      end
    end

    context "as regular user" do
      it "returns forbidden" do
        get api_v1_admin_events_path, headers: user_headers

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PUT /api/v1/admin/events/:id/update_review" do
    context "as admin" do
      it "updates review status" do
        put review_api_v1_admin_event_path(event),
              params: { status: :published },
              headers: admin_headers

        expect(response).to have_http_status(:ok)
        expect(event.reload.status).to eq("published")
      end
    end

    context "as regular user" do
      it "returns forbidden" do
        put review_api_v1_admin_event_path(event),
              params: { status: :published },
              headers: user_headers

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end

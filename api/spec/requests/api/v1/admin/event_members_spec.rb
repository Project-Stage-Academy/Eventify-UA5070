require "rails_helper"

RSpec.describe "Admin EventMembers API", type: :request do
  let!(:admin_role) { Role.create!(name: "admin") }
  let!(:user_role)  { Role.create!(name: "user") }

  let(:admin) { create(:user, :admin) }
  let(:user)  { create(:user) }
  let(:membership) { create(:event_member) }

  let(:admin_headers) { auth_headers_for(admin) }
  let(:user_headers)  { auth_headers_for(user) }
  let(:body) { JSON.parse(response.body) }

  describe "PUT /api/v1/admin/event_members/:id" do
    context "as admin" do
      it "updates membership rating/comment" do
        put api_v1_admin_event_member_path(membership),
            params: { event_member: { rating: 5, comment: "Good" } },
            headers: admin_headers

        expect(response).to have_http_status(:ok)
        membership.reload
        expect(membership.rating).to eq(5)
        expect(membership.comment).to eq("Good")
      end
    end

    context "as regular user" do
      it "returns forbidden" do
        put api_v1_admin_event_member_path(membership),
              params: { event_member: { rating: 5 } },
              headers: user_headers

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE /api/v1/admin/event_members/:id" do
    context "as admin" do
      it "cancels membership" do
        delete api_v1_admin_event_member_path(membership), headers: admin_headers

        expect(response).to have_http_status(:no_content)
        expect(EventMember.exists?(membership.id)).to be_falsey
      end
    end

    context "as regular user" do
      it "returns forbidden" do
        delete api_v1_admin_event_member_path(membership), headers: user_headers

        expect(response).to have_http_status(:forbidden)
        expect(EventMember.exists?(membership.id)).to be_truthy
      end
    end
  end
end

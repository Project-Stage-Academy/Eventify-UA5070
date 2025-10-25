require "rails_helper"

RSpec.describe "Api::V1::EventMembers", type: :request do
  let(:current_user) { create(:user) }
  let(:headers) { auth_headers_for(current_user) }
  let(:event) { create(:event) }

  describe "GET /api/v1/event_members" do
    before do
      create_list(:event_member, 3, user: current_user)
      create_list(:event_member, 3, event: event)
    end

    it "returns only the current user's event members with events and pagination meta" do
      get "/api/v1/event_members", headers: headers

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)

      expect(body["data"]).to be_an(Array)
      expect(body["data"]).not_to be_empty

      user_ids = body["data"].map { |em| EventMember.find_by(id: em["id"]).user_id }
      expect(user_ids).to all(eq(current_user.id))

      expect(body["included"]["events"]).to be_an(Array)
      expect(body["included"]["events"]).not_to be_empty

      expect(body["pagination"]).to be_present
    end

    context "when user has no event members" do
      it "returns an empty data array" do
        EventMember.where(user: current_user).delete_all

        get "/api/v1/event_members", headers: headers

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["data"]).to eq([])
      end
    end
  end

  describe "GET /api/v1/events/:event_id/memberships" do
    before do
      create_list(:event_member, 3, user: current_user)
      create_list(:event_member, 3, event: event)
    end

    it "returns the current user's event members for the specified event" do
      create(:event_member, user: current_user, event: event)

      get "/api/v1/events/#{event.id}/memberships", headers: headers

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)

      expect(body["data"]).to be_an(Array)
      expect(body["data"]).not_to be_empty

      user_ids = body["data"].map { |em| EventMember.find_by(id: em["id"]).user_id }
      expect(user_ids).to all(eq(current_user.id))

      event_ids = body["data"].map { |em| EventMember.find_by(id: em["id"]).event_id }
      expect(event_ids).to all(eq(event.id))
    end

    context "when user has no event members for the specified event" do
      it "returns an empty data array" do
        get "/api/v1/events/#{event.id}/memberships", headers: headers

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["data"]).to eq([])
      end
    end
  end

  describe "GET /api/v1/event_members/:id" do
    let!(:event_member) { create(:event_member, user: current_user, event: event) }

    it "returns the event member when it exists and belongs to the user" do
      get "/api/v1/event_members/#{event_member.id}", headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["data"]).to include("id" => event_member.id)
    end

    it "returns not found when the event member does not exist" do
      get "/api/v1/event_members/999999", headers: headers

      expect(response).to have_http_status(:not_found)
      body = JSON.parse(response.body)
      expect(body["error"]).to be_present
    end

    context "when the event member belongs to another user" do
      let!(:other_user_event_member) { create(:event_member) }
      it "returns forbidden if current user is not an admin" do
        get "/api/v1/event_members/#{other_user_event_member.id}", headers: headers

        expect(response).to have_http_status(:forbidden)
        body = JSON.parse(response.body)
        expect(body["error"]).to be_present
      end

      it "returns the event member if the current user is an admin" do
        current_user.add_role!(:admin)
        get "/api/v1/event_members/#{event_member.id}", headers: auth_headers_for(current_user)

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["data"]).to include("id" => event_member.id)
      end
    end
  end

  describe "POST /api/v1/events/:event_id/memberships" do
    let(:number_of_tickets) { 2 }
    let(:params) do
      {
        event_member: {
          number_of_tickets: number_of_tickets
        }
      }
    end

    it "creates event members for the current user" do
      event.update(status: :published)

      expect {
        post "/api/v1/events/#{event.id}/memberships", params: params, headers: headers, as: :json
      }.to change(EventMember, :count).by(number_of_tickets)

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["data"]).to be_an(Array)
      expect(body["data"].size).to eq(number_of_tickets)
    end

    it "enqueues a log entry creation job" do
      event.update(status: :published)

      expect {
        post "/api/v1/events/#{event.id}/memberships", params: params, headers: headers, as: :json
      }.to have_enqueued_job(LogEntryCreationJob).with(
        user_id: current_user.id,
        event_id: event.id,
        action: :event_member_created,
        metadata: hash_including(:ticket_qr_codes)
      )
    end

    context "with invalid params:" do
      it "nonexistent event returns not found error" do
        post "/api/v1/events/9999999/memberships", params: params, headers: headers, as: :json

        expect(response).to have_http_status(:not_found)
        body = JSON.parse(response.body)
        expect(body["error"]).to be_present
      end

      it "not joinable event returns validation error" do
        event.update(status: :draft_on_review)

        post "/api/v1/events/#{event.id}/memberships", params: params, headers: headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body["error"]).to be_present
      end

      it "requesting more tickets than available returns validation error" do
        event.update(participant_capacity: 1)

        post "/api/v1/events/#{event.id}/memberships", params: params, headers: headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body["error"]).to be_present
      end
    end
  end

  describe "PATCH /api/v1/event_members/:id" do
    let!(:event_member) { create(:event_member, user: current_user) }
    let(:params)  do
      {
        event_member: {
          rating: 4,
          comment: "Test comment"
        }
      }
    end

    it "allows the user to rate and comment on their event member" do
      patch "/api/v1/event_members/#{event_member.id}", params: params, headers: headers, as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["data"]["id"]).to eq(event_member.id)
    end

    context "with invalid params:" do
      it "when the event member belongs to another user returns forbidden" do
        patch "/api/v1/event_members/#{create(:event_member).id}", params: params, headers: headers, as: :json

        expect(response).to have_http_status(:forbidden)
        body = JSON.parse(response.body)
        expect(body["error"]).to be_present
      end

      it "returns validation error for nonexistent event member" do
        patch "/api/v1/event_members/9999999", params: params, headers: headers, as: :json

        expect(response).to have_http_status(:not_found)
        body = JSON.parse(response.body)
        expect(body["error"]).to be_present
      end

      it "returns validation error for comment without rating" do
        invalid_params = { event_member: { comment: "Test comment" } }

        patch "/api/v1/event_members/#{event_member.id}", params: invalid_params, headers: headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body["error"]).to be_present
      end
    end
  end
end

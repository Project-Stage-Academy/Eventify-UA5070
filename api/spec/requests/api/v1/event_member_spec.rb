require "rails_helper"

RSpec.describe "Api::V1::EventMembers", type: :request do
  let(:current_user) { create(:user) }
  let(:headers) { auth_headers_for(current_user) }
  let(:event) { create(:event) }
  let(:body) { JSON.parse(response.body) }

  describe "GET /api/v1/events/:event_id/members" do
    before do
      create_list(:event_member, 3, user: current_user)
      create_list(:event_member, 3, event: event)
    end

    context "when the request is valid" do
      let(:returned_ids) { body["data"].map { |em| em["id"] } }
      let(:returned_user_ids) { EventMember.where(id: returned_ids).pluck(:user_id) }
      let(:returned_event_ids) { EventMember.where(id: returned_ids).pluck(:event_id) }

      before do
        create(:event_member, user: current_user, event: event)

        get "/api/v1/events/#{event.id}/members", headers: headers
      end

      it "returns OK" do
        expect(response).to have_http_status(:ok)
      end

      it "returns array of event members" do
        expect(body["data"]).to be_an(Array)
        expect(body["data"]).not_to be_empty
      end

      it "returns event members only for the current user" do
        expect(returned_user_ids).to all(eq(current_user.id))
      end

      it "returns event members only for the specified event" do
        expect(returned_event_ids).to all(eq(event.id))
      end
    end

    context "when user has no event members for the specified event" do
      before { get "/api/v1/events/#{event.id}/members", headers: headers }

      it "returns OK" do
        expect(response).to have_http_status(:ok)
      end

      it "returns an empty data array" do
        expect(body["data"]).to eq([])
      end
    end
  end

  describe "GET /api/v1/events/:event_id/members/reviews" do
    context "when the request is valid" do
      let(:event_with_reviews) { create(:event) }
      let!(:reviewed_members) do
        create_list(:event_member, 5, event: event_with_reviews, rating: 4, comment: "Test comment")
      end

      before { get "/api/v1/events/#{event_with_reviews.id}/members/reviews", headers: headers }

      it "returns OK" do
        expect(response).to have_http_status(:ok)
      end

      it "returns array of reviews" do
        expect(body["data"]).to be_an(Array)
        expect(body["data"]).not_to be_empty
      end
    end

    context "when event has no reviews" do
      before { get "/api/v1/events/#{create(:event).id}/members/reviews", headers: headers }

      it "returns OK" do
        expect(response).to have_http_status(:ok)
      end

      it "returns an empty data array" do
        expect(body["data"]).to eq([])
      end
    end
  end


  describe "GET /api/v1/event_members/:id" do
    let!(:event_member) { create(:event_member, user: current_user, event: event) }

    context "when event member exists and belongs to the user" do
      before { get "/api/v1/event_members/#{event_member.id}", headers: headers }

      it "returns OK" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the event member" do
        expect(body["data"]).to include("id" => event_member.id)
      end
    end

    it "returns not found when the event member does not exist" do
      get "/api/v1/event_members/999999", headers: headers

      expect(response).to have_http_status(:not_found)
      expect(body["error"]).to be_present
    end

    context "when the event member belongs to another user" do
      let!(:other_user_event_member) { create(:event_member) }
      it "returns forbidden if current user is not an admin" do
        get "/api/v1/event_members/#{other_user_event_member.id}", headers: headers

        expect(response).to have_http_status(:forbidden)
        expect(body["error"]).to be_present
      end

      context "when the current user is an admin" do
        before do
          current_user.add_role!(:admin)
          get "/api/v1/event_members/#{event_member.id}", headers: auth_headers_for(current_user)
        end

        it "returns OK" do
          expect(response).to have_http_status(:ok)
        end

        it "returns the event member" do
          expect(body["data"]).to include("id" => event_member.id)
        end
      end
    end
  end

  describe "POST /api/v1/events/:event_id/members" do
    let(:number_of_tickets) { 2 }
    let(:params) do
      {
        event_member: {
          number_of_tickets: number_of_tickets
        }
      }
    end

    def request(event_id: event.id)
      post "/api/v1/events/#{event_id}/members", params: params, headers: headers, as: :json
    end

    context "when the request is valid" do
      before do
        event.update(status: :published)
        request
      end

      it "returns created status" do
        expect(response).to have_http_status(:created)
      end

      it "creates the event members" do
        expect { request }.to change(EventMember, :count).by(number_of_tickets)
      end

      it "returns the created event members" do
        expect(body["data"]).to be_an(Array)
        expect(body["data"].size).to eq(number_of_tickets)
      end

      it "enqueues a log entry creation job" do
        expect {
          request
        }.to have_enqueued_job(LogEntryCreationJob).with(
          user_id: current_user.id,
          event_id: event.id,
          action: :event_member_created,
          metadata: hash_including(:ticket_qr_codes)
        )
      end
    end

    context "with invalid params:" do
      it "nonexistent event returns not found error" do
        request(event_id: 9999999)

        expect(response).to have_http_status(:not_found)
        expect(body["error"]).to be_present
      end

      it "not joinable event returns validation error" do
        event.update(status: :draft_on_review)

        request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(body["error"]).to be_present
      end

      it "requesting more tickets than available returns validation error" do
        event.update(participant_capacity: 1)

        request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(body["error"]).to be_present
      end
    end
  end

  describe "PATCH /api/v1/event_members/:id" do
    let!(:event_member) { create(:event_member, user: current_user) }
    let(:rating) { 4 }
    let(:comment) { "Test comment" }
    let(:params)  do
      {
        event_member: {
          rating: rating,
          comment: comment
        }
      }
    end
    let(:invalid_params) do
      {
        event_member: {
          comment: "Test comment"
        }
      }
    end

    context "when the request is valid" do
      before { patch "/api/v1/event_members/#{event_member.id}", params: params, headers: headers, as: :json }

      it "returns OK" do
        expect(response).to have_http_status(:ok)
      end

      it "updates the event member's rating and comment" do
        event_member.reload
        expect(event_member.rating).to eq(rating)
        expect(event_member.comment).to eq(comment)
      end

      it "returns the updated event member" do
        expect(body["data"]["id"]).to eq(event_member.id)
      end
    end

    context "with invalid params:" do
      it "when the event member belongs to another user returns forbidden" do
        patch "/api/v1/event_members/#{create(:event_member).id}", params: params, headers: headers, as: :json

        expect(response).to have_http_status(:forbidden)
        expect(body["error"]).to be_present
      end

      it "returns validation error for nonexistent event member" do
        patch "/api/v1/event_members/9999999", params: params, headers: headers, as: :json

        expect(response).to have_http_status(:not_found)
        expect(body["error"]).to be_present
      end

      it "returns validation error for comment without rating" do
        patch "/api/v1/event_members/#{event_member.id}", params: invalid_params, headers: headers, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(body["error"]).to be_present
      end
    end
  end
end

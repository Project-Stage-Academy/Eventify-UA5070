require "rails_helper"

RSpec.describe "Api::V1::EventOrganizers", type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:event) { create(:event, organizer_user: user) }

  let(:access_token) do
    JwtService.issue_tokens_for(user)[:access_token]
  end

  let(:headers) do
    {
      "ACCEPT" => "application/json",
      "Authorization" => "Bearer #{access_token}"
    }
  end

  describe "POST /api/v1/events/:event_id/organizers" do
    context "when authorized" do
      it "adds a new organizer successfully" do
        post "/api/v1/events/#{event.id}/organizers",
             params: { user_id: another_user.id },
             headers: headers

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["id"]).to eq(another_user.id)
        expect(event.event_organizers.pluck(:user_id)).to include(another_user.id)
      end

      it "does not allow adding the same organizer twice" do
        create(:event_organizer, event: event, user: another_user)

        post "/api/v1/events/#{event.id}/organizers",
             params: { user_id: another_user.id },
             headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to be_present
      end
    end

    context "when unauthorized" do
      it "returns forbidden" do
        # user who is not an organizer
        unauthorized_token = JwtService.issue_tokens_for(another_user)[:access_token]

        post "/api/v1/events/#{event.id}/organizers",
             params: { user_id: create(:user).id },
             headers: { "Authorization" => "Bearer #{unauthorized_token}" }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE /api/v1/events/:event_id/organizers/:user_id" do
    context "when authorized" do
      it "removes an organizer successfully" do
        create(:event_organizer, event: event, user: another_user)

        delete "/api/v1/events/#{event.id}/organizers/#{another_user.id}", headers: headers

        expect(response).to have_http_status(:ok)
        expect(event.event_organizers.where(user_id: another_user.id)).to be_empty
      end

      it "returns 404 if organizer not found" do
        delete "/api/v1/events/#{event.id}/organizers/999", headers: headers

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to be_present
      end

      it "does not allow deleting the last organizer" do
        delete "/api/v1/events/#{event.id}/organizers/#{user.id}", headers: headers

        expect(response).to have_http_status(:forbidden).or have_http_status(:unprocessable_entity)
      end
    end

    context "when unauthorized" do
      it "returns forbidden" do
        unauthorized_token = JwtService.issue_tokens_for(another_user)[:access_token]

        delete "/api/v1/events/#{event.id}/organizers/#{user.id}",
               headers: { "Authorization" => "Bearer #{unauthorized_token}" }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end

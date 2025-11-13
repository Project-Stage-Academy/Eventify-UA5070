require "rails_helper"

RSpec.describe "Api::V1::EventOrganizers", type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:event) { create(:event, organizer_user: user) }

  let(:access_token) { JwtService.issue_tokens_for(user)[:access_token] }

  let(:headers) do
    {
      "ACCEPT" => "application/json",
      "Authorization" => "Bearer #{access_token}"
    }
  end

  describe "POST /api/v1/events/:event_id/organizers" do
    context "when authorized" do
      it "returns status created" do
        post "/api/v1/events/#{event.id}/organizers",
             params: { user_id: another_user.id },
             headers: headers

        expect(response).to have_http_status(:created)
      end

      it "returns correct user id in JSON" do
        post "/api/v1/events/#{event.id}/organizers",
             params: { user_id: another_user.id },
             headers: headers

        json = JSON.parse(response.body)
        expect(json["id"]).to eq(another_user.id)
      end

      it "adds the user to event organizers" do
        post "/api/v1/events/#{event.id}/organizers",
             params: { user_id: another_user.id },
             headers: headers

        expect(event.event_organizers.pluck(:user_id)).to include(another_user.id)
      end

      context "when organizer already exists" do
        before do
          event.event_organizers.create!(user: another_user)
        end

        it "does not allow adding the same organizer twice" do
          post "/api/v1/events/#{event.id}/organizers",
               params: { user_id: another_user.id },
               headers: headers

          expect(response).to have_http_status(:unprocessable_entity)

          data = JSON.parse(response.body)
          expect(data["errors"]).to include("User is already an organizer for this event")
        end
      end
    end

    context "when unauthorized" do
      it "returns forbidden" do
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

        delete "/api/v1/events/#{event.id}/organizers/#{another_user.id}",
               headers: headers

        expect(response).to have_http_status(:ok)
        expect(event.event_organizers.where(user_id: another_user.id)).to be_empty
      end

      it "returns 404 if organizer not found" do
        delete "/api/v1/events/#{event.id}/organizers/999", headers: headers

        expect(response).to have_http_status(:not_found)

        data = JSON.parse(response.body)
        expect(data["error"]).to eq(I18n.t("errors.common.organizer_not_found"))
      end

      it "does not allow deleting the last organizer" do
        delete "/api/v1/events/#{event.id}/organizers/#{user.id}", headers: headers

        expect(response).to have_http_status(:unprocessable_entity)

        data = JSON.parse(response.body)
        expect(data["error"]).to eq(I18n.t("activerecord.errors.models.event_organizer.messages.last_organizer_removal_forbidden"))
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

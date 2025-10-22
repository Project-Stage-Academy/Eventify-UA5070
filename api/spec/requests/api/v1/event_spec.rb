require 'rails_helper'

RSpec.describe "Api::V1::Events", type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_headers_for(user) }

  describe "GET /api/v1/events" do
    before do
      create_list(:event, 5)
    end

    it "returns a list of events with pagination meta" do
      get "/api/v1/events", headers: headers
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["data"]).to be_an(Array)
      expect(body["data"]).not_to be_empty
      expect(body["pagination"]).to be_present
    end

    context "when no events exist" do
      before { Event.delete_all }

      it "returns an empty data array" do
        get "/api/v1/events", headers: headers

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["data"]).to eq([])
      end
    end
  end

  describe "GET /api/v1/events/:id" do
    let!(:event) { create(:event) }

    it "returns the event when it exists" do
      get "/api/v1/events/#{event.id}", headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["data"]).to include("id" => event.id)
    end

    it "returns not found when the event does not exist" do
      get "/api/v1/events/999999", headers: headers

      expect(response).to have_http_status(:not_found)
      body = JSON.parse(response.body)
      expect(body["error"]).to be_present
    end
  end

  describe "POST /api/v1/events" do
    let(:valid_params) do
      {
        event: {
          title: "New Event",
          description: "Some description",
          location: "Kyiv",
          start_date: 2.days.from_now,
          finish_date: 3.days.from_now,
          ticket_price: 10.5,
          participant_capacity: 100,
          status: "draft"
        }
      }
    end

    it "creates a new event with valid params" do
      expect {
        post "/api/v1/events", params: valid_params, headers: headers
      }.to change(Event, :count).by(1)

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["data"]).to include("title" => "New Event")
    end

    it "raises a validation error with invalid params" do
      invalid_params = { event: { title: "" } }

      post "/api/v1/events", params: invalid_params, headers: headers

      expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:bad_request)
      body = JSON.parse(response.body)
      expect(body["error"]).to be_present
      expect(body.dig("error", "meta", "errors")).to be_present
    end

    context "when the title is not unique" do
      before { create(:event, title: "Unique Event") }
      it "returns a validation error" do
        post "/api/v1/events", params: { event: valid_params[:event].merge(title: "Unique Event") }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body["error"]).to be_present
        expect(body["error"]["meta"]["errors"]).to include("Title has already been taken")
      end
    end

    context "when start_date is in the past" do
      it "returns a validation error" do
        post "/api/v1/events", params: { event: valid_params[:event].merge(start_date: 2.days.ago) }, headers: headers
        puts JSON.pretty_generate(JSON.parse(response.body))
        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body["error"]).to be_present
        expect(body["error"]["meta"]["errors"]).to include("Start date The event's start date must be in the future")
      end
    end
  end
end

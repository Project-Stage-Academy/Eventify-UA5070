require 'rails_helper'

RSpec.describe "Api::V1::Events", type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_headers_for(user) }
  let(:body) { JSON.parse(response.body) }

  describe "GET /api/v1/events" do
    before do
      5.times do |i|
        create(:event, title: "Event #{i}")
      end
    end

      it "returns a list of events with pagination meta" do
        get "/api/v1/events", headers: headers
        expect(response).to have_http_status(:ok)

        expect(body["data"]).to be_an(Array)
        expect(body["data"]).not_to be_empty
        expect(body["pagination"]).to be_present
      end

    context "when no events exist" do
      before do
        EventOrganizer.delete_all
        Event.delete_all
      end

      it "returns an empty data array" do
        get "/api/v1/events", headers: headers

        expect(response).to have_http_status(:ok)
        expect(body["data"]).to eq([])
      end
    end
  end

  describe "GET /api/v1/events/joined" do
    let!(:joined_events) { create_list(:event, 3) }

    before do
      create_list(:event_member, 2)
    end

    context "when the user has joined events" do
      before do
        joined_events.each do |event|
          create(:event_member, user: user, event: event)
        end

        get "/api/v1/events/joined", headers: headers
      end

      it "returns OK" do
        expect(response).to have_http_status(:ok)
      end

      it "returns events array" do
        expect(body["data"]).to be_an(Array)
        expect(body["data"].size).to eq(joined_events.size)
      end

      it "returns pagination meta" do
        expect(body["pagination"]).to be_present
      end
    end

    context "when the user has not joined any events" do
      before { get "/api/v1/events/joined", headers: headers }

      it "returns OK" do
        expect(response).to have_http_status(:ok)
      end

      it "returns an empty data array" do
        expect(body["data"]).to eq([])
      end
    end
  end

  describe "GET /api/v1/events/:id" do
    let!(:event) { create(:event) }

    it "returns the event when it exists" do
      get "/api/v1/events/#{event.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(body["data"]).to include("id" => event.id)
    end

    it "returns not found when the event does not exist" do
      get "/api/v1/events/999999", headers: headers

      expect(response).to have_http_status(:not_found)
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
          start_date: (2.days.from_now + 5.minutes).iso8601,
          finish_date: (3.days.from_now + 10.minutes).iso8601,
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
      expect(body["data"]).to include("title" => "New Event")
    end

    it "raises a validation error with invalid params" do
      invalid_params = { event: { title: "" } }

      post "/api/v1/events", params: invalid_params, headers: headers

      expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:bad_request)
      expect(body["error"]).to be_present
      expect(body.dig("error", "meta", "errors")).to be_present
    end

    context "when the title is not unique" do
      before { create(:event, title: "Unique Event") }
      it "returns a validation error" do
        post "/api/v1/events", params: { event: valid_params[:event].merge(title: "Unique Event") }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(body["error"]).to be_present
        expect(body["error"]["meta"]["errors"]).to include("Title has already been taken")
      end
    end

    context "when start_date is in the past" do
      it "returns a validation error" do
        post "/api/v1/events", params: { event: valid_params[:event].merge(start_date: 2.days.ago) }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(body["error"]).to be_present
        expect(body["error"]["meta"]["errors"]).to include("Start date The event's start date must be in the future")
      end
    end
  end
end

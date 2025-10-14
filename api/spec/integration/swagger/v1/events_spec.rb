require 'swagger_helper'

RSpec.describe 'Events API', type: :request do
  path '/api/v1/events' do
    get 'Lists all events' do
      tags 'Events'
      produces 'application/json'
      security [ bearerAuth: [] ]

      response '200', 'events found' do
        let(:Authorization) { "Bearer #{create(:user).token}" }
        run_test!
      end
    end

    post 'Creates an event' do
      tags 'Events'
      consumes 'application/json'
      produces 'application/json'
      security [ bearerAuth: [] ]

      parameter name: :event, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, maxLength: 128 },
          description: { type: :string, maxLength: 500 },
          location: { type: :string },
          start_date: { type: :string, format: 'date-time' },
          finish_date: { type: :string, format: 'date-time' },
          ticket_price: { type: :number, minimum: 0 },
          participant_capacity: { type: :integer, minimum: 1 },
          status: {
            type: :string,
            enum: %w[draft draft_on_review published rejected published_unverified published_on_review published_rejected archived cancelled]
          }
        },
        required: %w[title location start_date finish_date]
      }

      response '201', 'event created' do
        let(:Authorization) { "Bearer #{create(:user).token}" }
        let(:event) do
          {
            title: 'New Event',
            location: 'Kyiv',
            start_date: 2.days.from_now,
            finish_date: 3.days.from_now,
            ticket_price: 10.5,
            participant_capacity: 100,
            status: 'draft'
          }
        end
        run_test!
      end

      response '422', 'validation errors' do
        let(:Authorization) { "Bearer #{create(:user).token}" }
        let(:event) { { title: '' } }
        run_test!
      end
    end
  end
end

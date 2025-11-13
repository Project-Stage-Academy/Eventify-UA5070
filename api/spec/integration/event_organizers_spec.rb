require 'swagger_helper'

RSpec.describe 'EventOrganizers API', type: :request do
  path '/api/v1/events/{event_id}/organizers' do
    post 'Add an organizer to an event' do
      tags 'EventOrganizers'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer token'
      parameter name: :event_id, in: :path, type: :integer
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: { user_id: { type: :integer } },
        required: [ 'user_id' ]
      }

      let(:user) { create(:user) }
      let(:another_user) { create(:user) }
      let(:event) { create(:event, organizer_user: user) }
      let(:event_id) { event.id }
      let(:Authorization) { "Bearer #{JwtService.issue_tokens_for(user)[:access_token]}" }
      let(:body) { { user_id: another_user.id } }

      response '201', 'organizer added' do
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(another_user.id)
          expect(event.event_organizers.pluck(:user_id)).to include(another_user.id)
        end
      end

      response '403', 'forbidden' do
        let(:Authorization) { "Bearer #{JwtService.issue_tokens_for(another_user)[:access_token]}" }
        run_test!
      end

      response '422', 'unprocessable entity (duplicate organizer)' do
        before do
          create(:event_organizer, event: event, user: another_user)
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['errors']).not_to be_empty
        end
      end
    end
  end

  path '/api/v1/events/{event_id}/organizers/{user_id}' do
    delete 'Remove an organizer from an event' do
      tags 'EventOrganizers'
      produces 'application/json'

      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer token'
      parameter name: :event_id, in: :path, type: :integer
      parameter name: :user_id, in: :path, type: :integer

      let(:user) { create(:user) }
      let(:another_user) { create(:user) }
      let(:event) { create(:event, organizer_user: user) }
      let(:event_id) { event.id }
      let(:Authorization) { "Bearer #{JwtService.issue_tokens_for(user)[:access_token]}" }

      response '200', 'organizer removed' do
        let(:user_id) { another_user.id }

        before do
          create(:event_organizer, event: event, user: another_user)
        end

        run_test! do |response|
          expect(event.event_organizers.where(user_id: another_user.id)).to be_empty
        end
      end

      response '422', 'cannot remove last organizer' do
        let(:user_id) { user.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq(I18n.t("activerecord.errors.models.event_organizer.messages.last_organizer_removal_forbidden"))
        end
      end

      response '403', 'forbidden (not authorized)' do
        let(:user_id) { user.id }
        let(:Authorization) { "Bearer #{JwtService.issue_tokens_for(another_user)[:access_token]}" }
        run_test!
      end

      response '404', 'organizer not found' do
        let(:user_id) { 999 }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq(I18n.t("errors.common.organizer_not_found"))
        end
      end
    end
  end
end

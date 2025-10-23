require "swagger_helper"

RSpec.describe "EventMembers API", type: :request do
  let(:user) { create(:user) }
  let(:Authorization) { auth_headers_for(user)["Authorization"] }

  path "/api/v1/event_members" do
    get "List current user event memberships" do
      tags "EventMembers"
      consumes "application/json"
      produces "application/json"
      parameter name: :page, in: :query, required: false, description: "Page number for pagination",
        schema: { type: :integer, minimum: 1, default: 1 }
      parameter name: :per_page, in: :query, required: false, description: "Number of items per page",
        schema: { type: :integer, minimum: 1, maximum: 50, default: 10 }
      parameter name: :sort, in: :query, required: false, description: "Sort column name",
        schema: { type: :string, default: "rating" }
      parameter name: :direction, in: :query, required: false, description: "Sort order",
        schema: { type: :string, enum: %w[asc desc] }

      response "200", "OK" do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: { "$ref" => "#/components/schemas/event_member" }
            },
            included: {
              type: :object,
              properties: {
                events: {
                  type: :array,
                  items: { "$ref" => "#/components/schemas/event" }
                }
              }
            },
            pagination: { "$ref" => "#/components/schemas/pagination" }
          },
          required: %w[data included pagination]

        run_test!
      end

      response "401", "Unauthorized" do
        let(:Authorization) { nil }

        schema "$ref" => "#/components/schemas/error_object"

        run_test!
      end
    end
  end

  path "/api/v1/events/{event_id}/memberships" do
    get "List current user memberships for a specific event" do
      tags "EventMembers"
      consumes "application/json"
      produces "application/json"
      parameter name: :event_id, in: :path, type: :integer, required: true

      let(:event) { create(:event) }
      let(:event_id) { event.id }

      response "200", "OK" do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: { "$ref" => "#/components/schemas/event_member" }
            }
          },
          required: %w[data]

        run_test!
      end

      response "401", "Unauthorized" do
        let(:Authorization) { nil }

        schema "$ref" => "#/components/schemas/error_object"

        run_test!
      end
    end

    post "Create memberships (tickets) for current user" do
      tags "EventMembers"
      consumes "application/json"
      produces "application/json"
      parameter name: :event_id, in: :path, type: :integer, required: true
      parameter name: :event_member, in: :body, schema: {
        type: :object,
        properties: {
          event_member: {
            type: :object,
            properties: {
              number_of_tickets: { type: :integer, example: 2, minimum: 1 }
            },
            required: %w[number_of_tickets]
          }
        },
        required: %w[event_member]
      }

      let(:event_member) { { event_member: { number_of_tickets: 2 } } }

      response "201", "Created" do
        let(:event) { create(:event, status: :published) }
        let(:event_id) { event.id }

        schema type: :object, properties: {
          data: {
            type: :array,
            items: { "$ref" => "#/components/schemas/event_member" }
          }
        }, required: %w[data]

        run_test!
      end

      response "404", "Event not found" do
        let(:event_id) { 9_999_999 }

        schema "$ref" => "#/components/schemas/error_object"

        run_test!
      end

      response "422", "Unprocessable (not joinable or insufficient capacity)" do
        let(:event) { create(:event, status: :draft_on_review) }
        let(:event_id) { event.id }

        schema "$ref" => "#/components/schemas/error_object"

        run_test!
      end

      response "401", "Unauthorized" do
        let(:Authorization) { nil }
        let(:event_id) { create(:event).id }

        schema "$ref" => "#/components/schemas/error_object"

        run_test!
      end
    end
  end

  path "/api/v1/event_members/{id}" do
    get "Show event member" do
      tags "EventMembers"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer, required: true

      response "200", "OK" do
        schema type: :object,
          properties: {
            data: { "$ref" => "#/components/schemas/event_member" }
          },
          required: %w[data]

        let(:event_member_record) { create(:event_member, user: user) }
        let(:id) { event_member_record.id }

        run_test!
      end

      response "404", "Not Found" do
        let(:id) { 9_999_999 }

        schema "$ref" => "#/components/schemas/error_object"

        run_test!
      end

      response "403", "Forbidden (current user is not an admin and belongs to another user)" do
        let(:id) { create(:event_member).id }

        schema "$ref" => "#/components/schemas/error_object"

        run_test!
      end

      response "401", "Unauthorized" do
        let(:id) { create(:event_member).id }
        let(:Authorization) { nil }

        schema "$ref" => "#/components/schemas/error_object"

        run_test!
      end
    end

    patch "Update rating and review comment" do
      tags "EventMembers"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer, required: true
      parameter name: :event_member, in: :body, schema: {
        type: :object,
        properties: {
          event_member: {
            type: :object,
            properties: {
              rating: { type: :integer, example: 4, minimum: 1, maximum: 5 },
              comment: { type: :string, example: "Great event" }
            }
          }
        },
        required: %w[event_member]
      }

      let(:event_member) { { event_member: { rating: 4, comment: "Test comment" } } }
      let(:record) { create(:event_member, user: user) }
      let(:id) { record.id }

      response "200", "OK" do
        schema type: :object,
          properties: {
            data: { "$ref" => "#/components/schemas/event_member" }
          },
          required: %w[data]

        run_test!
      end

      response "403", "Forbidden (belongs to another user)" do
        let(:id) { create(:event_member).id }

        schema "$ref" => "#/components/schemas/error_object"

        run_test!
      end

      response "404", "Not Found" do
        let(:id) { 9_999_999 }

        schema "$ref" => "#/components/schemas/error_object"

        run_test!
      end

      response "422", "Unprocessable (comment without rating)" do
        let(:event_member) { { event_member: { comment: "Test comment" } } }

        run_test!
      end

      response "401", "Unauthorized" do
        let(:Authorization) { nil }

        schema "$ref" => "#/components/schemas/error_object"

        run_test!
      end
    end
  end
end

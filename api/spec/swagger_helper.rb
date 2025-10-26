require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.1.0',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: ENV.fetch('SWAGGER_SERVER_URL', 'http://localhost:3000'),
          description: 'Local server'
        }
      ],
      components: {
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT
          }
        },
        parameters: {
          AuthorizationHeader: {
            name: :Authorization,
            in: :header,
            required: true,
            schema: {
              type: :string,
              example: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
            },
            description: 'Bearer token. Required role: user'
          }
        },
        schemas: {
          error_object: {
            type: :object,
            properties: {
              error: {
                type: :object,
                properties: {
                  code: { type: :string },
                  title: { type: :string },
                  detail: { type: :string },
                  meta: { type: :object, nullable: true }
                },
                required: %w[code title detail]
              }
            },
            required: %w[error]
          },
          pagination: {
            type: :object,
            properties: {
              current_page: { type: :integer },
              total_pages: { type: :integer },
              total_count: { type: :integer }
            },
            required: %w[current_page total_pages total_count]
          },
          event_member: {
            type: :object,
            properties: {
              id: { type: :integer },
              ticket_qr_code: { type: :string },
              rating: { type: :integer, nullable: true },
              comment: { type: :string, nullable: true },
              event_id: { type: :integer }
            },
            required: %w[id ticket_qr_code rating comment event_id]
          },
          event: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              location: { type: :string },
              start_date: { type: :string, format: "date-time" },
              finish_date: { type: :string, format: "date-time" },
              ticket_price: { type: :string },
              status: { type: :string }
            },
            required: %w[id title location start_date finish_date ticket_price status]
          }
        }
      },
      security: [ { bearerAuth: [] } ]
    }
  }

  config.swagger_format = :yaml
end

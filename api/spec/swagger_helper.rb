require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Eventify API',
        version: 'v1',
        description: 'API documentation for Events'
      },
      paths: {},
      servers: [
        {
          url: ENV.fetch('SWAGGER_SERVER_URL', 'http://localhost:3000'),
          description: 'Local server',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ],
      components: {
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT
          }
        }
      },
      security: [ { bearerAuth: [] } ]
    }
  }

  config.swagger_format = :yaml
end

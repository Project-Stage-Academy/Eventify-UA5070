module ParamValidation
  extend ActiveSupport::Concern

  included do
    def validate_id_param(id: :id)
      schema = Dry::Schema.Params do
        required(id).filled(:integer, gt?: 0)
      end

      result = schema.call(params.to_unsafe_h)

      unless result.success?
        render json: { errors: result.errors.to_h }, status: :unprocessable_entity
      end

      result
    end
  end
end

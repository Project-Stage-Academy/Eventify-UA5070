module Api
  module V1
    IdParamSchema = Dry::Schema.Params do
      required(:id).filled(:integer, gt?: 0)
    end
  end
end


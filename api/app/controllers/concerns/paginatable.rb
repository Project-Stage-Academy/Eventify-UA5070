module Paginatable
  extend ActiveSupport::Concern

  def paginate(scope, params)
    per_page = [ params[:per_page].to_i, 50 ].min
    per_page = 10 if per_page <= 0
    scope.page(params[:page]).per(per_page)
  end
end

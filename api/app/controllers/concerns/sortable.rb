module Sortable
  extend ActiveSupport::Concern

  def sort(scope, params, sortable_columns)
    sort_column = sortable_columns[params[:sort].to_s] || :id
    sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction].to_sym : :asc
    scope.order(sort_column => sort_direction)
  end
end

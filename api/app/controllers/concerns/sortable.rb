module Sortable
  extend ActiveSupport::Concern

  def sort(scope, params, sortable_columns)
    sort_column = sortable_columns[params[:sort].to_s] || :id
    sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction].to_sym : :asc

    column = scope.arel_table[sort_column]
    scope.order(column.send(sort_direction).nulls_last)
  end
end

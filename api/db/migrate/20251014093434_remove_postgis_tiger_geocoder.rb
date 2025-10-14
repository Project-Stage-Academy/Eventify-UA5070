class RemovePostgisTigerGeocoder < ActiveRecord::Migration[8.0]
  def change
    execute "DROP EXTENSION IF EXISTS postgis_tiger_geocoder;"
  end
end

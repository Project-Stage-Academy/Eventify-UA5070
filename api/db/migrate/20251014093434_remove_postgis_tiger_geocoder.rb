class RemovePostgisTigerGeocoder < ActiveRecord::Migration[8.0]
  def up
    execute "DROP EXTENSION IF EXISTS postgis_tiger_geocoder;"
  end

  def down
    execute "CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;"
  end
end

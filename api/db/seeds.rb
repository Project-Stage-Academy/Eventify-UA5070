# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

DETERMINISTIC_SEED = 42
Faker::Config.random = Random.new(DETERMINISTIC_SEED)
srand(DETERMINISTIC_SEED)

ActiveRecord::Base.transaction do
  load Rails.root.join("db/seeds/roles.rb")
  load Rails.root.join("db/seeds/users.rb")
  load Rails.root.join("db/seeds/events.rb")
  load Rails.root.join("db/seeds/event_members.rb")
end

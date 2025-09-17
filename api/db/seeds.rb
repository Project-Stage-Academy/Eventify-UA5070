# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear old data (optional)
Event.destroy_all

# EVENTS
Event.create!([
  {
    title: "Ruby on Rails Workshop",
    description: "Інтенсивний воркшоп по веб-додатках на Rails.",
    location: "Kyiv, Ukraine",
    start_date: 2.days.from_now,
    finish_date: 2.days.from_now + 3.hours,
    participant_capacity: 30,
    ticket_price: 50.0,
    status: "published",
    organizer: nil
  },
  {
    title: "Frontend Meetup",
    description: "Meetup для фронтенд-ентузіастів: React, Vue, Angular.",
    location: "Lviv, Ukraine",
    start_date: 5.days.from_now,
    finish_date: 5.days.from_now + 4.hours,
    participant_capacity: 50,
    ticket_price: 0.0,
    status: "draft",
    organizer: nil
  },
  {
    title: "AI & Machine Learning Seminar",
    description: "Семінар про сучасні методи штучного інтелекту.",
    location: "Berlin, Germany",
    start_date: 10.days.from_now,
    finish_date: 10.days.from_now + 2.hours,
    participant_capacity: 100,
    ticket_price: 100.0,
    status: "in_review",
    organizer: nil
  },
  {
    title: "Music Festival",
    description: "Щорічний музичний фестиваль з живими виступами.",
    location: "Odesa, Ukraine",
    start_date: 20.days.from_now,
    finish_date: 20.days.from_now + 8.hours,
    participant_capacity: 500,
    ticket_price: 150.0,
    status: "published",
    organizer: nil
  },
  {
    title: "Startup Pitch Night",
    description: "Презентація стартапів для потенційних інвесторів.",
    location: "Munich, Germany",
    start_date: 15.days.from_now,
    finish_date: 15.days.from_now + 3.hours,
    participant_capacity: 75,
    ticket_price: 20.0,
    status: "draft",
    organizer: nil
  }
])

puts "Seeds created: #{Event.count} events."

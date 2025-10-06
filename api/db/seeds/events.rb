# SEED_RESET=true rails db:seed
Event.delete_all if ENV["SEED_RESET"] == "true"

alice = User.find_by(email: "alice@example.com")
bob   = User.find_by(email: "bob@example.com")
charlie = User.find_by(email: "charlie@example.com")

events_data = [
  {
    title: "Ruby on Rails Workshop",
    description: "Intensive workshop on building web applications with Ruby on Rails.",
    location: "Kyiv, Ukraine",
    coordinates: "POINT(30.5238 50.4547)",
    start_date: 2.days.from_now,
    finish_date: 2.days.from_now + 3.hours,
    participant_capacity: 30,
    ticket_price: 50.0,
    event_status: :published,
    review_status: :unverified,
    review_comment: nil,
    organizers: [
      { user: alice, is_primary: true },
      { user: bob, is_primary: false }
    ]
  },
  {
    title: "Frontend Meetup",
    description: "Meetup for frontend enthusiasts: React, Vue, Angular.",
    location: "Lviv, Ukraine",
    coordinates: "POINT(24.0316 49.8397)",
    start_date: 5.days.from_now,
    finish_date: 5.days.from_now + 4.hours,
    participant_capacity: 50,
    ticket_price: 0.0,
    event_status: :draft,
    review_status: :on_review,
    review_comment: nil,
    organizers: [
      { user: bob, is_primary: true }
    ]
  },
  {
    title: "Music Festival",
    description: "Annual music festival with live performances.",
    location: "Odesa, Ukraine",
    coordinates: "POINT(30.7326 46.4825)",
    start_date: 20.days.from_now,
    finish_date: 20.days.from_now + 8.hours,
    participant_capacity: 500,
    ticket_price: 150.0,
    event_status: :published,
    review_status: :approved,
    review_comment: "Ready for publishing",
    organizers: [
      { user: bob, is_primary: true },
      { user: charlie, is_primary: false }
    ]
  }
]

events_data.each do |attrs|
  organizers = attrs.delete(:organizers)

  event = Event.new(attrs)
  event.save!(validate: false)  

  organizers.each do |org|
    raise "User not found: #{org.inspect}" if org[:user].nil?
    EventOrganizer.create!(event: event, user: org[:user], is_primary: org[:is_primary] || false)
  end

  event.reload
  event.save! 
end

puts "Event seeds created."

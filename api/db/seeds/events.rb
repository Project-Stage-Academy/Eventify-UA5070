if ENV["SEED_RESET"] == "true"
  EventMember.delete_all
  Event.delete_all
end

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
    status: :published,
    review_comment: nil
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
    status: :draft,
    review_comment: nil
  },
  {
    title: "AI & Machine Learning Seminar",
    description: "Seminar on modern artificial intelligence techniques.",
    location: "Berlin, Germany",
    coordinates: "POINT(13.4050 52.5200)",
    start_date: 10.days.from_now,
    finish_date: 10.days.from_now + 2.hours,
    participant_capacity: 100,
    ticket_price: 100.0,
    status: :published,
    review_comment: nil
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
    status: :published,
    review_comment: "Ready for publishing"
  },
  {
    title: "Startup Pitch Night",
    description: "Presentation of startups for potential investors.",
    location: "Munich, Germany",
    coordinates: "POINT(11.5820 48.1351)",
    start_date: 15.days.from_now,
    finish_date: 15.days.from_now + 3.hours,
    participant_capacity: 75,
    ticket_price: 20.0,
    status: :draft,
    review_comment: nil
  }
]

begin
  events_data.each do |attrs|
    Event.find_or_initialize_by(title: attrs[:title]).update!(attrs.except(:title))
  end
rescue => e
  puts "Seed error: #{e.message}"
end

puts "Event seeds created."

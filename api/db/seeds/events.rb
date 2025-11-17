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
  },
  {
    title: "DevOps Conference 2025",
    description: "Conference on modern DevOps practices and tools.",
    location: "Warsaw, Poland",
    coordinates: "POINT(21.0122 52.2297)",
    start_date: 7.days.from_now,
    finish_date: 7.days.from_now + 6.hours,
    participant_capacity: 200,
    ticket_price: 75.0,
    status: :published,
    review_comment: nil
  },
  {
    title: "Blockchain & Crypto Meetup",
    description: "Discussion about blockchain technology and cryptocurrencies.",
    location: "Kharkiv, Ukraine",
    coordinates: "POINT(36.2304 49.9935)",
    start_date: 3.days.from_now,
    finish_date: 3.days.from_now + 2.hours,
    participant_capacity: 40,
    ticket_price: 0.0,
    status: :published,
    review_comment: nil
  },
  {
    title: "UI/UX Design Workshop",
    description: "Practical workshop on modern UI/UX design principles.",
    location: "Prague, Czech Republic",
    coordinates: "POINT(14.4378 50.0755)",
    start_date: 8.days.from_now,
    finish_date: 8.days.from_now + 4.hours,
    participant_capacity: 25,
    ticket_price: 60.0,
    status: :published,
    review_comment: nil
  },
  {
    title: "Cybersecurity Summit",
    description: "Annual summit on cybersecurity trends and best practices.",
    location: "Vienna, Austria",
    coordinates: "POINT(16.3738 48.2082)",
    start_date: 12.days.from_now,
    finish_date: 12.days.from_now + 8.hours,
    participant_capacity: 150,
    ticket_price: 120.0,
    status: :published,
    review_comment: nil
  },
  {
    title: "Mobile Development Bootcamp",
    description: "Intensive bootcamp on iOS and Android development.",
    location: "Dnipro, Ukraine",
    coordinates: "POINT(35.0462 48.4647)",
    start_date: 6.days.from_now,
    finish_date: 6.days.from_now + 5.hours,
    participant_capacity: 35,
    ticket_price: 80.0,
    status: :draft,
    review_comment: nil
  },
  {
    title: "Data Science Workshop",
    description: "Workshop on data analysis, machine learning and Python.",
    location: "Budapest, Hungary",
    coordinates: "POINT(19.0402 47.4979)",
    start_date: 9.days.from_now,
    finish_date: 9.days.from_now + 6.hours,
    participant_capacity: 60,
    ticket_price: 90.0,
    status: :published,
    review_comment: nil
  },
  {
    title: "Game Development Conference",
    description: "Conference for game developers and enthusiasts.",
    location: "Krakow, Poland",
    coordinates: "POINT(19.9450 50.0647)",
    start_date: 14.days.from_now,
    finish_date: 14.days.from_now + 7.hours,
    participant_capacity: 120,
    ticket_price: 85.0,
    status: :published,
    review_comment: nil
  },
  {
    title: "Cloud Computing Meetup",
    description: "Meetup about AWS, Azure, and Google Cloud Platform.",
    location: "Zaporizhzhia, Ukraine",
    coordinates: "POINT(35.1396 47.8388)",
    start_date: 4.days.from_now,
    finish_date: 4.days.from_now + 3.hours,
    participant_capacity: 45,
    ticket_price: 0.0,
    status: :published,
    review_comment: nil
  },
  {
    title: "Python Developer Meetup",
    description: "Meetup for Python developers of all levels.",
    location: "Bratislava, Slovakia",
    coordinates: "POINT(17.1077 48.1486)",
    start_date: 11.days.from_now,
    finish_date: 11.days.from_now + 3.hours,
    participant_capacity: 50,
    ticket_price: 10.0,
    status: :draft,
    review_comment: nil
  },
  {
    title: "JavaScript Conference",
    description: "Annual JavaScript conference with workshops and talks.",
    location: "Amsterdam, Netherlands",
    coordinates: "POINT(4.9041 52.3676)",
    start_date: 18.days.from_now,
    finish_date: 18.days.from_now + 8.hours,
    participant_capacity: 250,
    ticket_price: 150.0,
    status: :published,
    review_comment: nil
  },
  {
    title: "E-commerce & Marketing",
    description: "Workshop on e-commerce strategies and digital marketing.",
    location: "Vinnytsia, Ukraine",
    coordinates: "POINT(28.4682 49.2331)",
    start_date: 13.days.from_now,
    finish_date: 13.days.from_now + 4.hours,
    participant_capacity: 40,
    ticket_price: 45.0,
    status: :published,
    review_comment: nil
  },
  {
    title: "Product Management Summit",
    description: "Summit for product managers and product owners.",
    location: "London, UK",
    coordinates: "POINT(-0.1278 51.5074)",
    start_date: 22.days.from_now,
    finish_date: 22.days.from_now + 6.hours,
    participant_capacity: 180,
    ticket_price: 200.0,
    status: :published,
    review_comment: nil
  },
  {
    title: "IoT & Smart Devices",
    description: "Conference on Internet of Things and smart devices.",
    location: "Chernivtsi, Ukraine",
    coordinates: "POINT(25.9358 48.2921)",
    start_date: 16.days.from_now,
    finish_date: 16.days.from_now + 5.hours,
    participant_capacity: 55,
    ticket_price: 70.0,
    status: :draft,
    review_comment: nil
  },
  {
    title: "Agile & Scrum Workshop",
    description: "Practical workshop on Agile methodologies and Scrum.",
    location: "Brussels, Belgium",
    coordinates: "POINT(4.3517 50.8503)",
    start_date: 19.days.from_now,
    finish_date: 19.days.from_now + 4.hours,
    participant_capacity: 30,
    ticket_price: 65.0,
    status: :published,
    review_comment: nil
  },
  {
    title: "Digital Art Exhibition",
    description: "Exhibition of digital art and NFT collections.",
    location: "Ivano-Frankivsk, Ukraine",
    coordinates: "POINT(24.7111 48.9226)",
    start_date: 21.days.from_now,
    finish_date: 21.days.from_now + 6.hours,
    participant_capacity: 100,
    ticket_price: 25.0,
    status: :published,
    review_comment: nil
  },
  {
    title: "Tech Career Fair",
    description: "Career fair for IT professionals and students.",
    location: "Stockholm, Sweden",
    coordinates: "POINT(18.0686 59.3293)",
    start_date: 17.days.from_now,
    finish_date: 17.days.from_now + 5.hours,
    participant_capacity: 300,
    ticket_price: 0.0,
    status: :published,
    review_comment: nil
  },
  {
    title: "AR/VR Innovation Lab",
    description: "Workshop on augmented and virtual reality development.",
    location: "Poltava, Ukraine",
    coordinates: "POINT(34.5514 49.5883)",
    start_date: 23.days.from_now,
    finish_date: 23.days.from_now + 4.hours,
    participant_capacity: 20,
    ticket_price: 95.0,
    status: :draft,
    review_comment: nil
  },
  {
    title: "Open Source Contribution Day",
    description: "Day dedicated to contributing to open source projects.",
    location: "Chernihiv, Ukraine",
    coordinates: "POINT(31.2893 51.4982)",
    start_date: 24.days.from_now,
    finish_date: 24.days.from_now + 8.hours,
    participant_capacity: 65,
    ticket_price: 0.0,
    status: :published,
    review_comment: nil
  },
  {
    title: "FinTech Innovation Forum",
    description: "Forum on financial technology and innovations.",
    location: "Frankfurt, Germany",
    coordinates: "POINT(8.6821 50.1109)",
    start_date: 25.days.from_now,
    finish_date: 25.days.from_now + 7.hours,
    participant_capacity: 140,
    ticket_price: 110.0,
    status: :published,
    review_comment: nil
  },
  {
    title: "Quality Assurance Meetup",
    description: "Meetup for QA engineers and testers.",
    location: "Sumy, Ukraine",
    coordinates: "POINT(34.8000 50.9077)",
    start_date: 26.days.from_now,
    finish_date: 26.days.from_now + 3.hours,
    participant_capacity: 35,
    ticket_price: 15.0,
    status: :draft,
    review_comment: nil
  },
  {
    title: "Robotics & Automation Expo",
    description: "Expo showcasing latest robotics and automation technologies.",
    location: "Copenhagen, Denmark",
    coordinates: "POINT(12.5683 55.6761)",
    start_date: 28.days.from_now,
    finish_date: 28.days.from_now + 10.hours,
    participant_capacity: 400,
    ticket_price: 180.0,
    status: :published,
    review_comment: nil
  }
]

events_data.each do |attrs|
  Event.find_or_initialize_by(title: attrs[:title]).update!(attrs.except(:title))
end

puts "Event seeds created."

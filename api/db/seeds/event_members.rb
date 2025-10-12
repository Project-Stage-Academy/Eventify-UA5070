def create_event_member!(event, user, rating: nil, comment: nil, qr_tag: nil)
  qr = Digest::SHA256.hexdigest("#{user.id}:#{event.id}:#{qr_tag}")[0, 10]

  EventMember.find_or_create_by!(ticket_qr_code: qr) do |em|
    em.event = event
    em.user = user
    em.rating = rating
    em.comment = comment
  end
end

users = Role.for(:user).users.order(:id).to_a
events = Event.order(:id).to_a
rated_event = events.first

users.each_with_index do |user, i|
  rand(1..3).times do |j|
    create_event_member!(
      events[(i + j) % events.size],
      user,
      qr_tag: "base_#{j}"
    )
  end

  create_event_member!(
    rated_event,
    user,
    rating: rand(1..5),
    comment: Faker::Lorem.sentence,
    qr_tag: "rated_#{i}"
  )
end

puts "EventMember seeds created."

def create_event_member!(event, user, rating: nil, comment: nil, qr_tag: nil)
  qr = Digest::SHA256.hexdigest("#{user.id}:#{event.id}:#{qr_tag}")[0, EventMember::QR_CODE_LENGTH]

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

users.sample(10).each_with_index do |user, i|
  events.sample(2).each do |event|
    create_event_member!(event, user, qr_tag: "base_#{i}")
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

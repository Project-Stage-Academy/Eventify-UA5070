def create_event_member!(event, user, rating: nil, comment: nil)
  qr = Digest::SHA256.hexdigest("#{user.id}:#{event.id}")[0, EventMember::QR_CODE_LENGTH]

  EventMember.find_or_create_by!(ticket_qr_code: qr) do |em|
    em.event = event
    em.user = user
    em.rating = rating
    em.comment = comment
  end
end

users = Role.for(:user).users.order(:id).to_a
events = Event.order(:id).to_a

users.sample(10).each_with_index do |user, i|
  events.sample(2).each do |event|
    rating = [ nil, *1..5 ].sample

    create_event_member!(
      event,
      user,
      rating: rating,
      comment: rating ? Faker::Lorem.sentence : nil
    )
  end
end

events.each(&:update_rating_fields!)

puts "EventMember seeds created."

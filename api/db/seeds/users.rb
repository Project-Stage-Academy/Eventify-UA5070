if ENV["SEED_RESET"] == "true"
  UserRole.delete_all
  User.delete_all
end

users_data = [
  { name: "Alice", email: "alice@example.com", password: "password" },
  { name: "Bob", email: "bob@example.com", password: "password" },
  { name: "Charlie", email: "charlie@example.com", password: "password" },
  { name: "David", email: "david@example.com", password: "password" }
]

users_data.each do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |u|
    u.name = attrs[:name]
    u.password = attrs[:password]
  end
end

puts "Users seeds created."

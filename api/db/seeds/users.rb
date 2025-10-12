if ENV["SEED_RESET"] == "true"
  UserRole.delete_all
  User.delete_all
end

def create_user!(role_key, index)
  role_value = Role::NAMES[role_key]
  user = User.find_or_create_by!(email: "#{role_key}_#{role_value}_#{index}@example.com") do |u|
      u.password = "password"
      u.name = Faker::Name.name
    end

  user.add_role!(role_value)
end

25.times { |i| create_user!(:user, i) }
5.times { |i| create_user!(:admin, i) }

puts "User and UserRole seeds created."

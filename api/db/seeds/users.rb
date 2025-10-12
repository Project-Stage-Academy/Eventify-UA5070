if ENV["SEED_RESET"] == "true"
  UserRole.delete_all
  User.delete_all
end

def create_user!(role, index)
  user = User.find_or_create_by!(email: "#{role}_#{index}@example.com") do |u|
      u.password = "password"
      u.name = Faker::Name.name
    end

  user.add_role!(role)
end

25.times { |i| create_user!(Role::NAMES[:user], i) }
5.times { |i| create_user!(Role::NAMES[:admin], i) }

puts "User and UserRole seeds created."

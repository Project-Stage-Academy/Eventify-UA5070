if ENV["SEED_RESET"] == "true"
  UserRole.delete_all
  Role.delete_all
end

Role::NAMES.values.each do |val|
  Role.find_or_create_by!(name: val)
end

puts "Role seeds created."

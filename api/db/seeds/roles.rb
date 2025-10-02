Role::NAMES.values.each do |val|
  Role.find_or_create_by!(name: val)
end

class UserRole < ApplicationRecord
  self.primary_key = [ :user_id, :role_id ]

  belongs_to :user
  belongs_to :role
end

class User < ApplicationRecord
  has_secure_password

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :event_members, dependent: :destroy
  has_many :joined_events, through: :event_members, source: :event

  has_many :event_organizers, dependent: :destroy
  has_many :organized_events, through: :event_organizers, source: :event

  normalizes :email, with: ->(e) { e.to_s.strip.downcase }

  validates :name, presence: true, length: { maximum: 64 }
  validates :email, presence: true, length: { maximum: 128 },
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: true
  validates :password, presence: true

  def add_role!(key)
    role = Role.for(key)
    roles << role unless roles.exists?(id: role.id)
  end

  def has_role?(key)
    roles.exists?(name: Role.value(key))
  end
end

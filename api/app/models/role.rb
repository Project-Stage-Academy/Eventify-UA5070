class Role < ApplicationRecord
  NAMES = { user: "user", admin: "admin" }.freeze

  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles

  normalizes :name, with: ->(n) { n.to_s.downcase }

  validates :name, presence: true, length: { maximum: 64 },
                   uniqueness: true, inclusion: { in: NAMES.values }

  def self.value(key) = NAMES.fetch(key.to_sym)

  def self.for(key) = find_by!(name: value(key))

  scope :by, ->(key) { where(name: value(key)) }
end

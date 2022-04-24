class Group < ApplicationRecord
  has_many :tasks

  validates :name, :team_id, presence: true
  validates :name, length: { maximum: 50 }
  validates :name, uniqueness: { scope: :team_id }

  AUTHORITY_ADMIN = %w[admin owner].freeze
  AUTHORITY_OWNER = %w[owner].freeze
end

class Group < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :name, :team_id, presence: true
  validates :name, length: { maximum: 50 }
  validates :name, uniqueness: { scope: :team_id }
  validate :change_team_id_validation, on: :update

  AUTHORITY_ADMIN = %w[admin owner].freeze
  AUTHORITY_OWNER = %w[owner].freeze

  def hash_for_edit
    team = RestClient.get_team_details(team_id)

    {
      id: id,
      name: name,
      team_name: team[:name],
      team_description: team[:description],
      personal_flag: team[:personal_flag],
      created_at: created_at.iso8601,
      updated_at: updated_at.iso8601
    }
  end

  private

  def change_team_id_validation
    errors.add(:team_id, I18n.t('errors.messages.invalid_change')) if team_id_changed?
  end
end

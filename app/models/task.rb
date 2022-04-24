class Task < ApplicationRecord
  belongs_to :group
  belongs_to :status

  validates :title, presence: true, length: { maximum: 50 }
  validates :detail, length: { maximum: 250 }
  validates :sort_number, presence: true, uniqueness: { scope: :group }
end

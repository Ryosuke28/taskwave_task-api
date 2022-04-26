class Task < ApplicationRecord
  belongs_to :group
  belongs_to :status

  validates :title, presence: true, length: { maximum: 50 }
  validates :detail, length: { maximum: 250 }
  validates :sort_number, presence: true, uniqueness: { scope: :group }

  before_validation :add_sort_number

  def hash_for_edit
    {
      id: id,
      title: title,
      group_id: group_id,
      status_id: status_id,
      deadline: deadline,
      detail: detail,
      sort_number: sort_number,
      user_id: user_id,
      created_at: created_at.iso8601,
      updated_at: updated_at.iso8601
    }
  end

  private

  def add_sort_number
    return if sort_number

    last_sort_number = Group.find(group_id).tasks.pluck(:sort_number).max
    self.sort_number = last_sort_number.present? ? last_sort_number.next : 1
  end
end

class AddGroupUniqueValidation < ActiveRecord::Migration[6.1]
  def change
    add_index :groups, [:name, :team_id], unique: true
  end
end

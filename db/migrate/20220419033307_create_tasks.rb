class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.references :group, null: false, foreign_key: true
      t.references :status, null: false, foreign_key: true
      t.date :deadline
      t.string :detail
      t.integer :sort_number, null: false
      t.integer :user_id

      t.timestamps
    end
  end
end

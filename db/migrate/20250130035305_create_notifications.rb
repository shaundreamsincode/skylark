class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :target_id, null: false
      t.string :target_type, null: false
      t.text :message

      t.timestamps
    end
  end
end

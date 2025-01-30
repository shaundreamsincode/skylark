class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.integer :name, null: 0, index: { unique: true } # enum
      t.timestamps
    end
  end
end

class CreatePageViews < ActiveRecord::Migration[6.1]
  def change
    create_table :page_views do |t|
      t.references :user, null: true, foreign_key: true
      t.string :page_name
      t.string :ip_address
      t.text :user_agent

      t.timestamps
    end
  end
end

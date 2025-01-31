class CreateInformationRequestResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :information_request_responses do |t|
      t.references :information_request, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end

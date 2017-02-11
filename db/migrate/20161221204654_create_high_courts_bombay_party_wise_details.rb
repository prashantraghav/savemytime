class CreateHighCourtsBombayPartyWiseDetails < ActiveRecord::Migration
  def change
    create_table :high_courts_bombay_party_wise_details do |t|
      t.string :link
      t.string :response_code
      t.text :response_body, :limit=> 4000.megabytes - 1
      t.integer :high_courts_bombay_party_wise_result_id

      t.timestamps null: false
    end
  end
end

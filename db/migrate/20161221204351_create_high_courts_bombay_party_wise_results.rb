class CreateHighCourtsBombayPartyWiseResults < ActiveRecord::Migration
  def change
    create_table :high_courts_bombay_party_wise_results do |t|
      t.string :name
      t.string :year
      t.string :bench
      t.string :jurisdiction
      t.string :pet_or_res
      t.string :response_code
      t.text :response_body, :limit=> 4000.megabytes - 1
      t.integer :high_courts_bombay_party_wise_search_id

      t.timestamps null: false
    end
  end
end

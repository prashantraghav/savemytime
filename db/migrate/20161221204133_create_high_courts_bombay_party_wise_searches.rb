class CreateHighCourtsBombayPartyWiseSearches < ActiveRecord::Migration
  def change
    create_table :high_courts_bombay_party_wise_searches do |t|
      t.string :status
      t.text :params
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

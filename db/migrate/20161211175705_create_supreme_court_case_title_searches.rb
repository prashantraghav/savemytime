class CreateSupremeCourtCaseTitleSearches < ActiveRecord::Migration
  def change
    create_table :supreme_court_case_title_searches do |t|
      t.string :status
      t.text :params
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

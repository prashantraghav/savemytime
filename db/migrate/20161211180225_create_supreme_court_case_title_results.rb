class CreateSupremeCourtCaseTitleResults < ActiveRecord::Migration
  def change
    create_table :supreme_court_case_title_results do |t|
      t.string :title
      t.string :year
      t.string :response_code
      t.text :response_body, :limit=> 4000.megabytes - 1
      t.integer :supreme_court_case_title_search_id

      t.timestamps null: false
    end
  end
end

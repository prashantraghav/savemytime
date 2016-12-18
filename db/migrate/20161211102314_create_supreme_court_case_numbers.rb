class CreateSupremeCourtCaseNumbers < ActiveRecord::Migration
  def change
    create_table :supreme_court_case_numbers do |t|
      t.string :case_type
      t.string :case_number
      t.string :year
      t.string :response_code
      t.text :response_body
      t.integer :search_id

      t.timestamps null: false
    end
  end
end

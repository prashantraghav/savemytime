class CreateEcourts < ActiveRecord::Migration
  def change
    create_table :ecourts do |t|
      t.integer :state_code
      t.integer :dist_code
      t.string :court_type
      t.integer :court_code
      t.string :name
      t.integer :year
      t.string :response_code
      t.text :response_body

      t.references :search
      t.timestamps null: false
    end
  end
end

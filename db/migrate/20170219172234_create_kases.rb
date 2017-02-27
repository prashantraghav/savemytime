class CreateKases < ActiveRecord::Migration
  def change
    create_table :kases do |t|
      t.string :no
      t.string :name
      t.integer :from_year
      t.integer :to_year
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.text :params
      t.references :user
      t.timestamps null: false
    end
  end
end

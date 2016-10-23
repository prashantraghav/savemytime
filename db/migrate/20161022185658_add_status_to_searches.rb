class AddStatusToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :status, :string
  end
end

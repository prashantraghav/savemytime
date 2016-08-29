class AddStateCodeAndDistCodeToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :state_code, :string, :after=>:id
    add_column :searches, :dist_code, :string, :after=>:state_code
  end
end

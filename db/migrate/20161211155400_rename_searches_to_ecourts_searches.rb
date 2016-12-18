class RenameSearchesToEcourtsSearches < ActiveRecord::Migration
  def up
    rename_table :searches, :ecourts_searches
  end

  def down
    rename_table :ecourts_searches, :searches
  end
end

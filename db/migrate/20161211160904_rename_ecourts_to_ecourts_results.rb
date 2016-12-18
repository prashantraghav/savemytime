class RenameEcourtsToEcourtsResults < ActiveRecord::Migration

  def up
    rename_table :ecourts, :ecourts_results
    ActiveRecord::Base.connection.execute("update ecourts_results set court_type=concat('Ecourts::', court_type)")
  end

  def down
    rename_table :ecourts_results, :ecourts
    ActiveRecord::Base.connection.execute("update ecourts set court_type=replace(court_type, 'Ecourts::', '')")
  end

end

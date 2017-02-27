class AddKaseIdToAllCourtSearches < ActiveRecord::Migration
  def change
    add_column :ecourts_searches, :kase_id, :integer
    add_column :supreme_court_case_title_searches, :kase_id, :integer
    add_column :high_courts_bombay_party_wise_searches, :kase_id, :integer
  end
end

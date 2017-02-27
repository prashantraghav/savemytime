class Kase < ActiveRecord::Base
  has_one :ecourts_search, :class_name=>'Ecourts::Search', :dependent => :destroy
  has_one :supreme_court_case_title_search, :class_name=>'SupremeCourt::CaseTitle::Search', :dependent => :destroy
  has_one :high_courts_bombay_party_wise_search, :class_name=>'HighCourts::Bombay::PartyWise::Search', :dependent => :destroy

  belongs_to :user

  #default_scope {where('user_id NOT IN (?, ?)', User.first.id, 4)}

  scope :today, ->{where('DATE(created_at) = DATE(?)', Time.now)}
  scope :yesterday, ->{where('DATE(created_at) = DATE(?)', Time.now.yesterday)}

  scope :this_week, ->{where('Date(created_at) >=DATE(?) and DATE(created_at) <= DATE(?)', Time.now.beginning_of_week, Time.now)}
  scope :last_week, ->{where('Date(created_at) >=DATE(?) and DATE(created_at) <= DATE(?)', (Time.now - 1.week).beginning_of_week, (Time.now - 1.week).end_of_week)}

  scope :this_month, ->{where('Date(created_at) >=DATE(?) and DATE(created_at) <= DATE(?)', Time.now.beginning_of_month, Time.now)}
  scope :last_month, ->{where('Date(created_at) >=DATE(?) and DATE(created_at) <= DATE(?)', (Time.now - 1.month).beginning_of_month , (Time.now - 1.month).end_of_month)}

  scope :on_date, ->(date){where("DATE(created_at) = DATE(?) ",  date )}
  scope :between_date, ->(from_date, to_date){where("DATE(created_at) between DATE(?) and DATE(?)",  from_date, to_date)}

  def successful?
    (ecourts_search.try(:successful?) || supreme_court_case_title_search.try(:successful?) || high_courts_bombay_party_wise_search.try(:successful?)) ? true : false
  end
end

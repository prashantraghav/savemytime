class SupremeCourt::CaseTitle::Search < ActiveRecord::Base

  has_many :results, :class_name=>'SupremeCourt::CaseTitle::Result', :foreign_key => "supreme_court_case_title_search_id"

  belongs_to :user

  serialize :params

  before_create :set_status

  default_scope {where('user_id NOT IN (?, ?)', User.first.id, 4)}

  scope :today, ->{where('DATE(created_at) = DATE(?)', Time.now)}
  scope :yesterday, ->{where('DATE(created_at) = DATE(?)', Time.now.yesterday)}

  scope :this_week, ->{where('Date(created_at) >=DATE(?) and DATE(created_at) <= DATE(?)', Time.now.beginning_of_week, Time.now)}
  scope :last_week, ->{where('Date(created_at) >=DATE(?) and DATE(created_at) <= DATE(?)', (Time.now - 1.week).beginning_of_week, (Time.now - 1.week).end_of_week)}

  scope :this_month, ->{where('Date(created_at) >=DATE(?) and DATE(created_at) <= DATE(?)', Time.now.beginning_of_month, Time.now)}
  scope :last_month, ->{where('Date(created_at) >=DATE(?) and DATE(created_at) <= DATE(?)', (Time.now - 1.month).beginning_of_month , (Time.now - 1.month).end_of_month)}

  scope :on_date, ->(date){where("DATE(created_at) = DATE(?) ",  date )}
  scope :between_date, ->(from_date, to_date){where("DATE(created_at) between DATE(?) and DATE(?)",  from_date, to_date)}

  scope :successful, ->(from_id=SupremeCourt::CaseTitle::Result.first.try(:id), to_id=SupremeCourt::CaseTitle::Result.last.try(:id)){ 
    where(:id=> SupremeCourt::CaseTitle::Result.successful_response.where('supreme_court_case_title_search_id between ? and ?', from_id , to_id).pluck(:search_id).uniq)
  }

  def self.chargable_count
    (successful.length - successful.of_mumbai.length) + (successful.of_mumbai.length/6)
  end

  def successful?
    (court_complexes.successful_response.present? || court_establishment.successful_response.present?) ? true : false
  end

  def unsuccessful?
    !successful?
  end

  def get_result
    processing

     params['from_year'].to_i.upto(params['to_year'].to_i).each do |year|
        court_params = {:title=>params['title'], :year=>year}
        e = results.new(court_params).get_result
     end

    completed
  end


  private

  def processing
    self.status="processing"
    self.save
  end

  def completed
    self.status="completed"
    self.save
  end

  def set_status
    self.status = "created"
  end

end

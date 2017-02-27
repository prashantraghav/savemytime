class Ecourts::Search < ActiveRecord::Base

  has_many :court_complexes, :dependent=>:destroy, :class_name=>'Ecourts::CourtComplex'
  has_many :court_establishments, :dependent=>:destroy, :class_name=>'Ecourts::CourtEstablishment'

  belongs_to :user
  belongs_to :kase

  serialize :params

  before_create :set_status

  #default_scope {where('user_id NOT IN (?, ?)', User.first.id, 4)}

  scope :today, ->{where('DATE(created_at) = DATE(?)', Time.now)}
  scope :yesterday, ->{where('DATE(created_at) = DATE(?)', Time.now.yesterday)}

  scope :this_week, ->{where('Date(created_at) >=DATE(?) and DATE(created_at) <= DATE(?)', Time.now.beginning_of_week, Time.now)}
  scope :last_week, ->{where('Date(created_at) >=DATE(?) and DATE(created_at) <= DATE(?)', (Time.now - 1.week).beginning_of_week, (Time.now - 1.week).end_of_week)}

  scope :this_month, ->{where('Date(created_at) >=DATE(?) and DATE(created_at) <= DATE(?)', Time.now.beginning_of_month, Time.now)}
  scope :last_month, ->{where('Date(created_at) >=DATE(?) and DATE(created_at) <= DATE(?)', (Time.now - 1.month).beginning_of_month , (Time.now - 1.month).end_of_month)}

  scope :on_date, ->(date){where("DATE(created_at) = DATE(?) ",  date )}
  scope :between_date, ->(from_date, to_date){where("DATE(created_at) between DATE(?) and DATE(?)",  from_date, to_date)}

  scope :free, ->{where("DATE(created_at) between DATE(?) and DATE(?)",  Date.new(2016, 8, 1), Date.new(2016, 8, 15))}

  scope :of_mumbai, ->{where("state_code=1 and dist_code in ('42', '43', '37', '23', '39', '38')")}
  scope :of_mumbai_count, ->{of_mumbai.count/6}

  scope :successful, ->(from_id=Ecourts::Search.first.try(:id), to_id=Ecourts::Search.last.try(:id)){ 
    where(:id=> Ecourts::Result.successful_response.where('search_id between ? and ?', from_id , to_id).pluck(:search_id).uniq)
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

  def of_mumbai?
    state_code=="1" && ['42', '43', '37', '23', '39', '38'].include?(dist_code.to_s)
  end

  def free?
    (created_at.to_date >= Date.new(2016, 8, 1) && created_at.to_date <= Date.new(2016, 8, 15))
  end


  def get_result
    processing
        
    params["court_complex"].try(:each) do |i, court|
      params['from_year'].to_i.upto(params['to_year'].to_i).each do |year|
        court_params = {:state_code=>params['state_code'], :dist_code=>params['dist_code'],:name=>params['name'], :year=>year, :court_code=>court["code"]}
        e = court_complexes.new(court_params).result
      end
    end

    params["court_establishment"].try(:each) do |i, court|
      params['from_year'].to_i.upto(params['to_year'].to_i).each do |year|
        court_params = {:state_code=>params['state_code'], :dist_code=>params['dist_code'],:name=>params['name'], :year=>year, :court_code=>court["code"]}
        e = court_establishments.new(court_params).result
      end
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

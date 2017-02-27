class HighCourts::Bombay::PartyWise::Search < ActiveRecord::Base

  has_many :results, :class_name=>'HighCourts::Bombay::PartyWise::Result', :foreign_key => "high_courts_bombay_party_wise_search_id"

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

  scope :successful, ->(from_id=HighCourts::Bombay::PartyWise::Result.first.try(:id), to_id=HighCourts::Bombay::PartyWise::Result.last.try(:id)){ 
    where(:id=> HighCourts::Bombay::PartyWise::Result.successful_response.where('high_courts_bombay_party_wise_search_id between ? and ?', from_id , to_id).pluck(:search_id).uniq)
  }

  def self.chargable_count
    (successful.length - successful.of_mumbai.length) + (successful.of_mumbai.length/6)
  end

  def successful?
    (results.successful_response.present?) ? true : false
  end

  def unsuccessful?
    !successful?
  end

  def get_result
    processing

    params['benches'].each do |bench|
      juries = self.class.bench_juri[bench].split(',')
      juries.each do |juri|
        self.class.pet_and_res.each do |key, value|
          pet_or_res = key
          params['from_year'].to_i.upto(params['to_year'].to_i).each do |year|
            court_params = {:name=>params['title'], :year=>year, :pet_or_res=>pet_or_res, :jurisdiction=>juri, :bench=>bench}
            e = results.new(court_params).get_result
          end
        end
      end
    end

    completed
  end

  def formatted_results
    res = {'01'=>{}, '02'=>{}, '03'=>{}}
    self.class.bench_juri.each do |bench, juri|
      res[bench]={}
        (params[:from_year].to_i..params[:to_year].to_i).each do |year|
          res[bench][year] = results.where(:bench=>bench).where(:year=>year)
        end
    end
    res
  end
=begin
  def formatted_results
    res = {'01'=>{}, '02'=>{}, '03'=>{}}
    self.class.bench_juri.each do |bench, juri|
      res[bench]={}
      juri.split(',').each do |j|
        res[bench][j]={}
        (params[:from_year].to_i..params[:to_year].to_i).each do |year|
          res[bench][j][year] = results.where(:bench=>bench).where(:jurisdiction=>j).where(:year=>year)
        end
      end
    end
    res
  end
=end

  private

  def self.bench
    {'01'=>"Bombay", '02'=>'Aurangabad', '03'=>'Nagpur'}
  end
  
  def self.jurisdiction
    {'C'=>"Civil", 'CR'=>'Criminal', 'OR'=>'Original'}
  end

  def self.bench_juri
    {'01'=>"C,CR,OR", "02"=>"C,CR", "03"=>"C,CR"}
  end

  def self.pet_and_res
    {'P'=>'Petitioner', 'R'=>'Respondent'}
  end

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

class Search < ActiveRecord::Base
  has_many :court_complexes
  has_many :court_establishments

  belongs_to :user

  serialize :params

  default_scope {where('user_id != ?', User.first.id)}

  scope :today, ->{where('DATE(created_at) = DATE(?)', Time.now)}
  scope :yesterday, ->{where('DATE(created_at) = DATE(?)', Time.now.yesterday)}
  
  scope :this_week, ->{where('Date(created_at) >=DATE(?) and DATE(created_at) <= DATE(?)', Time.now.beginning_of_week, Time.now)}
  scope :last_week, ->{where('Date(created_at) >=DATE(?) and DATE(created_at) <= DATE(?)', (Time.now - 1.week).beginning_of_week, (Time.now - 1.week).end_of_week)}

  scope :this_month, ->{where('Date(created_at) >=DATE(?) and DATE(created_at) <= DATE(?)', Time.now.beginning_of_month, Time.now)}
  scope :last_month, ->{where('Date(created_at) >=DATE(?) and DATE(created_at) <= DATE(?)', (Time.now - 1.month).beginning_of_month , (Time.now - 1.month).end_of_month)}

  scope :of_mumbai, ->{where("state_code=1 and dist_code in ('42', '43', '37', '23', '39', '38')")}

  def self.set_state_and_dist_code
    # run with unscoped
    where('state_code is null').each do |s|
      h = eval s.params
      s.state_code = h['state_code']
      s.dist_code = h['dist_code']
      s.save
    end
  end
end

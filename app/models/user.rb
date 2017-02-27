class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  has_many :ecourts_searches, :class_name=>"Ecourts::Search"
  has_many :supreme_court_case_title_searches, :class_name=>"SupremeCourt::CaseTitle::Search"
  has_many :high_courts_bombay_party_wise_searches, :class_name=>"HighCourts::Bombay::PartyWise::Search"

  has_many :kases

  after_create :lock
  after_save :never_lock_super_admin, :never_revoke_admin_privileges_from_super_admin #super_admin is first user.

  #default_scope {where('id != ?', User.first.id)}

  def lock
    self.lock_access!(:send_instructions=>false)
  end

  def unlock
    self.unlock_access!
  end

  def grant_admin
    self.admin = true
    save
  end

  def revoke_admin
    self.admin = false
    self.save
  end

  private

  def never_lock_super_admin
    user = User.first
    user.unlock_access! if user.access_locked?
  end

  def never_revoke_admin_privileges_from_super_admin
    user = User.first
    user.grant_admin unless user.admin?
  end

end

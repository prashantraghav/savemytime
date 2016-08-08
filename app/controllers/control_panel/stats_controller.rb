class ControlPanel::StatsController < ApplicationController
  
  before_action :all_searches, :my_searches
  
  def index
    @users = User.all.reject{|u| u.id == User.first.id}
  end


  private

  def all_searches
    @searches = {:total=>Search.count, 
                 :yesterday=>Search.yesterday.count, 
                 :this_week=>Search.this_week.count, 
                 :last_week=>Search.last_week.count, 
                 :this_month=>Search.this_month.count, 
                 :last_month=>Search.last_month.count, 
                 :today=>Search.today.count}
  end

  def my_searches
    @my_searches = {:total=>current_user.searches.count, 
                    :yesterday=>current_user.searches.yesterday.count, 
                    :this_week=>current_user.searches.this_week.count, 
                    :last_week=>current_user.searches.last_week.count, 
                    :this_month=>current_user.searches.this_month.count, 
                    :last_month=>current_user.searches.last_month.count, 
                    :today=>current_user.searches.today.count
    }
  end
end

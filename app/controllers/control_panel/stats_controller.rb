class ControlPanel::StatsController < ApplicationController
  def index
    @my_searches = current_user.searches.count
    @total_searches = Search.count
    @users = User.all
  end
end

class ControlPanel::StatsController < ApplicationController
  include SharedHelper
  
  before_action  :filter_by, :all_searches, :my_searches, :active_page
  
  def index
    @users = User.all.reject{|u| [User.first.id, 4].include?(u.id)}
  end


  private

  def my_searches
    @my_searches = Hash.new
    searches = current_user.searches.send(@filter_by.to_sym, *@filter_params)

    @my_searches[:all] = {:total=>searches.count}

    @my_searches[:successful] = { 
        :total=>searches.successful.count,
        :of_mumbai=>{:total=>searches.successful.of_mumbai.count, :count=>searches.successful.of_mumbai_count}
    }

    @my_searches[:chargable] = searches.chargable_count

  end


  def all_searches
    @searches = Hash.new
    searches = Search.send(@filter_by.to_sym, *@filter_params)

    @searches[:all] = {:total=>searches.count}

    @searches[:successful] = { 
        :total=>searches.successful.count,
        :of_mumbai=>{:total=>searches.successful.of_mumbai.count, :count=>searches.successful.of_mumbai_count}
    }
    @searches[:chargable] = searches.chargable_count
  end

  def active_page
    @active_link = control_panel_stats_index_path
    @page_icon = "fa fa-bar-chart"
    @page_heading = "Stats"
    @page_desc = "Searches overview"
  end
end

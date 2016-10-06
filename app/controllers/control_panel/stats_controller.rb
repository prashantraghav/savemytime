class ControlPanel::StatsController < ApplicationController
  
  before_action  :filter_by, :all_searches, :my_searches, :active_page
  
  def index
    @users = User.all.reject{|u| u.id == User.first.id}
  end


  private

  def filter_by
    @filter_params = []
    @filter_by = params[:filter_by] || "today"

    case @filter_by
    when "on_date"
      @filter_params = [parse_date(params[:filter_on_date])]
    when "between_date"
      @filter_params = [parse_date(params[:filter_from_date]), parse_date(params[:filter_to_date])]
    end
  end

  def parse_date(date)
    date = date.split("-")
    date.reverse!
    Date.new(date[0].to_i, date[1].to_i, date[2].to_i)
  end

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

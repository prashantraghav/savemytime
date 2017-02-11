class SearchesController < ApplicationController
  include SharedHelper

  before_action :active_page, :filter_by

  def index
    case params[:court]
    when "supreme_court"
      supreme_court_searches
      @partial = "supreme_court/case_title/partials/list"
    when "bombay_high_court"
      bombay_high_court_searches
      @partial = "high_courts/bombay/party_wise/partials/list"
    else
      ecourt_searches
      @partial = "ecourt/partials/list"
    end

    @page_heading = "Searches"
    @page_desc = "List"
  end

  private
  
  def ecourt_searches
    @searches = (current_user.id == 1) ? Ecourts::Search.unscoped.send(@filter_by.to_sym, *@filter_params).order(:id=>:desc) 
                                       : current_user.ecourts_searches.send(@filter_by.to_sym, *@filter_params).order(:id=>:desc) 
  end

  def supreme_court_searches
    @searches = (current_user.id == 1) ? SupremeCourt::CaseTitle::Search.unscoped.send(@filter_by.to_sym, *@filter_params).order(:id=>:desc) 
                                       : current_user.supreme_court_case_title_search.send(@filter_by.to_sym, *@filter_params).order(:id=>:desc) 
  end

  def bombay_high_court_searches
    @searches = (current_user.id == 1) ? HighCourts::Bombay::PartyWise::Search.unscoped.send(@filter_by.to_sym, *@filter_params).order(:id=>:desc) 
                                       : current_user.high_courts_bombay_party_wise_search.send(@filter_by.to_sym, *@filter_params).order(:id=>:desc) 
  end


  def active_page
    @active_link = searches_path
    @page_icon = "fa fa-search"
  end

end

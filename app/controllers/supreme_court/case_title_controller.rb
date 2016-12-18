class SupremeCourt::CaseTitleController < ApplicationController

  def index
  end

  def search
    perform_search if request.post?
    @searches = (current_user.id == 1 ) ? SupremeCourt::CaseTitle::Search.unscoped.today.order(:id=>:desc) : SupremeCourt::CaseTitle::Search.today.order(:id=>:desc)
    render :layout=>false
  end

  def result
    @search = SupremeCourt::CaseTitle::Search.unscoped.find params[:id]
  end

  def details
    search = SupremeCourt::CaseTitle::Search.unscoped.find params[:id]
    @details = search.results.find(params[:result_id]).get_details(params['listcause'])
    render :layout=>false
  end

  private

  def perform_search
    search = current_user.supreme_court_case_title_searches.create(:params=>params)
    Delayed::Job.enqueue SearchJob.new(SupremeCourt::CaseTitle::Search, search.id)
  end

end

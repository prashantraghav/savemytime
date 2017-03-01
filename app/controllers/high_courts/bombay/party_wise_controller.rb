class HighCourts::Bombay::PartyWiseController < ApplicationController

  before_action :active_page, :set_kase

  def index
    @page_desc = "Parsing"
    redirect_to high_courts_bombay_party_wise_search_results_path(@kase.high_courts_bombay_party_wise_search.id) if @kase.high_courts_bombay_party_wise_search.present?
  end

  def search
    perform_search if request.post?
    @searches = (current_user.id == 1 ) ? HighCourts::Bombay::PartyWise::Search.unscoped.today.order(:id=>:desc) : HighCourts::Bombay::PartyWise::Search.today.order(:id=>:desc)
    render :layout=>false
  end

  def results
    @search = HighCourts::Bombay::PartyWise::Search.unscoped.find params[:id]
    @page_desc = "Results"
  end

  def result
    @result = HighCourts::Bombay::PartyWise::Result.unscoped.find params[:result_id]
    @page_desc = "Cases"
  end

  def details
    search = HighCourts::Bombay::PartyWise::Search.unscoped.find params[:id]
    @details = search.results.find(params[:result_id]).details.find(params[:details_id])
    @page_desc = "Case Details"
    render :layout=>false
  end

  private

  def perform_search
    search = current_user.high_courts_bombay_party_wise_searches.create(:params=>params, :kase_id=>@kase.id)
    Delayed::Job.enqueue SearchJob.new(HighCourts::Bombay::PartyWise::Search, search.id)
  end

  def active_page
    @active_link = high_courts_bombay_party_wise_index_path
    @page_icon = "fa fa-university"
    @page_heading = "Bombay High Court"
  end

  def set_kase
    @kase = Kase.unscoped.find_by_no(params[:case_no]) if params[:case_no]
  end

end

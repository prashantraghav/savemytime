class EcourtController < ApplicationController
  before_action :get_states, :active_page

  def index
    @results = Hash.new
    @results = get_result if request.post?
  end

  def districts
    @districts = get_districts.collect{|d| {:code=>d['code'], :name=>d['name']}}
    render :json=>@districts
  end

  def courts
    @courts = get_courts
    render :json=>@courts
  end

  def search
    @court_name = params['court_name']
    @state_code, @dist_code = params['state_code'], params['dist_code']
    perform_search if request.post?
    @searches = (current_user.id == 1 ) ? Ecourts::Search.unscoped.today.order(:id=>:desc) : Ecourts::Search.today.order(:id=>:desc)
    render :layout=>false
  end


  def result
    @search = Ecourts::Search.unscoped.find params[:id]
    @state_code  = @search.state_code
    @dist_code  = @search.dist_code

    @results = {:complex=>Hash.new, :establishment=>Hash.new}

    if @search.status.eql?("completed")
      params = @search.params

      params["court_complex"].try(:each) do |i, court|
        @results[:complex][court["code"]] = {:name=>court["name"], :results=>Hash.new}

        params['from_year'].to_i.upto(params['to_year'].to_i).each do |year|
          court_params = {:state_code=>params['state_code'], :dist_code=>params['dist_code'],:name=>params['name'], :year=>year, :court_code=>court["code"]}
          e = @search.court_complexes.find_by(court_params)
          @results[:complex][court["code"]][:results][year]=e.response_body
        end
      end

      params["court_establishment"].try(:each) do |i, court|
        @results[:establishment][court["code"]] = {:name=>court["name"], :results=>Hash.new}
        params['from_year'].to_i.upto(params['to_year'].to_i).each do |year|
          court_params = {:state_code=>params['state_code'], :dist_code=>params['dist_code'],:name=>params['name'], :year=>year, :court_code=>court["code"]}
          e = @search.court_establishments.find_by(court_params)
          @results[:establishment][court["code"]][:results][year]=e.response_body
        end
      end

    end


    @page_heading = "Ecourt Searches"
    @page_desc = "Result"

  end

  def details
     court_params = {:state_code=>params['state_code'], :dist_code=>params['dist_code'], :court_code=>params['court_code']}
     e = Ecourts::Result.new(court_params)
     @details = e.get_details(params['caseno'].match(/[0-9]*$/).to_s, params['cino'])

     render :layout=>false
  end


  private

  def get_states
    data = ECOURT_CONFIG_DATA
    @states = data['states']
  end

  def get_districts
    @states.select{|s| s['code'] == params[:state_code].to_i}.first['dist']
  end

  def get_courts
    dist = get_districts.select{|dist| dist['code'] == params[:dist_code].to_i}.first
    {:establishment => dist['court_establishment'], :complex=>dist['court_complex']}
  end

  def perform_search
    courts = get_courts
    search = current_user.ecourts_searches.create(:state_code=>params[:state_code], :dist_code=>params[:dist_code], :params=>params)
    Delayed::Job.enqueue SearchJob.new(Ecourts::Search, search.id)
  end

  def active_page
    @active_link = ecourt_path
    @page_icon = "fa fa-university"
    @page_heading = "Ecourt"
    @page_desc = "parsing"
  end
end

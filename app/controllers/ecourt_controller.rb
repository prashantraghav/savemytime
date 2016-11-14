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
    @searches = (current_user.id == 1 ) ? Search.unscoped.today.order(:id=>:desc) : Search.today.order(:id=>:desc)
    render :layout=>false
  end

  def details
     court_params = {:state_code=>params['state_code'], :dist_code=>params['dist_code'], :court_code=>params['court_code']}
     e = Ecourt.new(court_params)
     @details = e.get_details(params['caseno'].match(/[0-9]*$/).to_s, params['cino'])

     render :layout=>false
  end


  private

  def get_states
    data = YAML.load_file("#{Rails.root}/public/ecourt/states.yml")
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
    search = current_user.searches.create(:state_code=>params[:state_code], :dist_code=>params[:dist_code], :params=>params)
    Delayed::Job.enqueue SearchJob.new(search.id)
  end

  def active_page
    @active_link = ecourt_path
    @page_icon = "fa fa-university"
    @page_heading = "Ecourt"
    @page_desc = "parsing"
  end
end

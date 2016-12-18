class SearchesController < ApplicationController
  include SharedHelper

  before_action :active_page, :get_states, :filter_by

  def index
    @searches = (current_user.id == 1) ? Ecourts::Search.unscoped.send(@filter_by.to_sym, *@filter_params).order(:id=>:desc) 
                                       : current_user.ecourts_searches.send(@filter_by.to_sym, *@filter_params).order(:id=>:desc) 

    @page_heading = "Searches"
    @page_desc = "List"
  end

  def show
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


    @page_heading = "Search"
    @page_desc = "Result"
  end

  private

  def get_states
    data = YAML.load_file("#{Rails.root}/public/ecourt/states.yml")
    @states = data['states']
  end

  def active_page
    @active_link = searches_path
    @page_icon = "fa fa-search"
  end

end

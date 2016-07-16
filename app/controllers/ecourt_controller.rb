class EcourtController < ApplicationController
  before_action :get_states

  def index
    @results = Hash.new
    @results = get_result if request.post?
  end

  def districts
    @districts = get_districts.collect{|d| {:code=>d['code'], :name=>d['name']}}
    render :json=>@districts
  end

  def courts
    @courts = get_courts[params['court_type'].to_sym].collect{|c| {:code=>c['code'], :name=>c['name']}}
    render :json=>@courts
  end

  def search
    @court_name = params['court_name']
    time_started = Time.now
    @results = get_result
    time_taken = Time.now - time_started
    @time = time_taken.divmod(60)
  end

  def details
     court_params = {:state_code=>params['state_code'], :dist_code=>params['dist_code'], :court_code=>params['court_code']}
     e = Ecourt.new(court_params)
     @details = e.get_details(URI.unescape(params['caseno'].match(/[0-9]*$/).to_s), params['cino'])
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

  def get_result
    results = Hash.new
    params['from_year'].to_i.upto(params['to_year'].to_i).each do |year|
        court_params = {:state_code=>params['state_code'], :dist_code=>params['dist_code'],:name=>params['name'], :year=>year}
        court_params.merge! (params['court_type'].eql?('complex')) ? {:court_code_arr=>params['court_code']} : {:court_code=>params['court_code']} 

        e = Ecourt.new(court_params)
        results[year] = e.get_result
    end
    return results
  end

=begin
  def get_result_old
    results = {:complex=>Hash.new, :establishment=>Hash.new}
    courts = get_courts
    params['from_year'].to_i.upto(params['to_year'].to_i).each do |year|
      results[:complex][year] = Hash.new
      results[:establishment][year] = Hash.new

      courts[:complex].each do |court|
        e = Ecourt.new(:state_code=>params['state_code'], :dist_code=>params['dist_code'], :court_code_arr=>court['code'], :name=>params['name'], :year=>year)
        results[:complex][year][court['name']] = e.get_result
      end

      courts[:establishment].each do |court|
        e = Ecourt.new(:state_code=>params['state_code'], :dist_code=>params['dist_code'], :court_code=>court['code'], :name=>params['name'], :year=>year)
        results[:establishment][year][court['name']] = e.get_result
      end

    end
    return results
  end
=end
end

class HighCourts::Bombay::PartyWise::Result < ActiveRecord::Base

  belongs_to :search, :class_name=>'HighCourts::Bombay::PartyWise::Search', :foreign_key => "high_courts_bombay_party_wise_search_id" 

  has_many :details, :class_name=>'HighCourts::Bombay::PartyWise::Detail', :foreign_key => "high_courts_bombay_party_wise_result_id" 

  scope :successful_response, ->{where(:response_code=>200)}

  def get_response_body
    body = read_attribute(:response_body)
    (body.match(/form name="casepfrm"/i)) ?  Nokogiri::HTML(response_body).css('form[name="casepfrm"] > table') : "" unless body.nil?
  end

  def get_result
    set_response_object
    resp  = get_response
    self.response_code = resp.try(:code)
    self.response_body = resp.try(:body)
    self.save!
    get_details
    return self
  end

  def get_details
    Nokogiri::HTML(response_body).css('a[href^="casequery_action"]').each do |link|
      detail = details.new(:link=>link.values.first)
      detail.get_detail(@response_object)
    end
  end

  def get_response
    tries ||= 3
    resp = nil

    begin
      resp  = @response_object.search
    rescue => e
      Rails.logger.info "HighCourts::Bombay::PartyWise::Result Exception - #{e.inspect}" unless Rails.env.production?
      resp = e.response if e.class.to_s.eql?('ResponseError')
      retry unless(tries-=1).zero?
    end

    return resp
  end

  def search_id
    high_courts_bombay_party_wise_search_id 
  end

  def no_of_cases
    (get_response_body.size >= 4 ) ? get_response_body.size - 4 : 0
  end

  private

  def set_response_object
    court_params = {:bench=>bench, :name=>name, :jurisdiction=>jurisdiction, :pet_or_res=>pet_or_res, :year=>year}
    @response_object = HighCourtResponse::Bombay::PartyWise.new(court_params)
  end



end

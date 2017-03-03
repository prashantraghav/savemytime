class SupremeCourt::CaseTitle::Result < ActiveRecord::Base
  attr_reader :response_body
  
  belongs_to :search, :class_name=>'SupremeCourt::CaseTitle::Search', :foreign_key => "supreme_court_case_title_search_id"

  scope :successful_response, ->{where(:response_code=>200)}

  def get_details(listcause)
    response_object.details(listcause).body
  end

  def response_body
    body = read_attribute(:response_body)
    Nokogiri::HTML(body).css('#select1 > option')
  end

  def get_result
    resp  = get_response
    self.response_code = resp.try(:code)
    self.response_body = resp.try(:body).to_s.encode("utf-8", :invalid => :replace, :undef => :replace)
    self.save!
    return self
  end

  def get_response
    tries ||= 3
    resp = nil
    court_params = {:title=>title, :year=>year}

    begin
      resp  = response_object.search
    rescue => e
      Rails.logger.info "Supreme Court Exception - #{e.inspect}" unless Rails.env.production?
      resp = e.response if e.class.to_s.eql?('SupremeCourtResponseError')
      retry unless(tries-=1).zero?
    end

    return resp
  end

  private

  def response_object
    court_params = {:title=>title, :year=>year}
    SupremeCourtResponse::Title.new(court_params)
  end

end

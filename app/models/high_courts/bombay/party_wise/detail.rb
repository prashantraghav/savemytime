class HighCourts::Bombay::PartyWise::Detail < ActiveRecord::Base

  belongs_to :result, :class_name=>'HighCourts::Bombay::PartyWise::Result', :foreign_key => "high_courts_bombay_party_wise_result_id"

  scope :successful_response, ->{where(:response_code=>200)}

  def get_detail(response_object)
    resp  = get_response(response_object)
    self.response_code = resp.try(:code)
    self.response_body = resp.try(:body)
    self.save!
    return self
  end

  def get_response(response_object)
    tries ||= 3 
    resp = nil 

    begin 
      resp  = response_object.details(link)
    rescue => e 
      Rails.logger.info "Supreme Court Exception - #{e.inspect}" unless Rails.env.production? 
      resp = e.response if e.class.to_s.eql?('SupremeCourtResponseError') 
      retry unless(tries-=1).zero? 
    end 

    return resp 
  end


end

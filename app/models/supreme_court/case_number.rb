class SupremeCourt::CaseNumber < ActiveRecord::Base
  attr_reader :response_body

  scope :successful_response, ->{where(:response_code=>200)}

  def response_body
    body = read_attribute(:response_body)
    body.gsub(/<input type="submit".*?>/, '')
  end

  def get_result
    resp  = get_ecourt_response
    self.response_code = resp.try(:code)
    self.response_body = resp.try(:body)
    self.save!
    return self
  end

  def get_response
    tries ||= 3
    resp = nil
    court_params = {:case_type=>case_type, :case_number=>case_number,:year=>year, :year=>year}

    begin
      resp  = SupremeCourtResponse::CaseNumber.new(court_params).search
    rescue => e
      Rails.logger.info "Supreme Court Exception - #{e.inspect}" unless Rails.env.production?
      resp = e.response if e.class.to_s.eql?('SupremeCourtResponseError')
      retry unless(tries-=1).zero?
    end

    return resp
  end
end

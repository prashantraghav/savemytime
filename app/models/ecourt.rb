class Ecourt < ActiveRecord::Base
  self.inheritance_column = :court_type
  attr_reader :response_body
  
  def get_details(caseno, cino)
    court_params = {:state_code=>state_code, :dist_code=>dist_code, :court_code=>court_code}
    e = EcourtResponse.new(court_params)
    e.details(caseno, cino).body
  end

  def response_body
    body = read_attribute(:response_body)
    (body.match(/#{name}/i)) ? body : "" unless body.nil?
  end

  protected

  def get_result(params)
    resp  = get_ecourt_response(params)
    self.response_code = resp.try(:code)
    self.response_body = resp.try(:body)
    self.save!
    return self
  end

  def get_ecourt_response(params)
    tries ||= 3
    resp = nil
    court_params = {:state_code=>state_code, :dist_code=>dist_code,:name=>name, :year=>year}.merge(params)

    begin
      resp  = EcourtResponse.new(court_params).search
    rescue => e
      puts e.inspect
      retry unless(tries-=1).zero?
    end

    return resp
  end
end

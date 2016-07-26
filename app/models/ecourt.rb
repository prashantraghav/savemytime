class Ecourt < ActiveRecord::Base
  self.inheritance_column = :court_type

  def get_details(caseno, cino)
    court_params = {:state_code=>state_code, :dist_code=>dist_code, :court_code=>court_code}
    e = EcourtResponse.new(court_params)
    e.details(caseno, cino).body
  end

  protected

  def get_result(params)
    court_params = {:state_code=>state_code, :dist_code=>dist_code,:name=>name, :year=>year}.merge(params)
    resp  = EcourtResponse.new(court_params).search
    self.response_code = resp.code
    self.response_body = resp.body
    self.save!
    return self
  end
end

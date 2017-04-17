class Ecourts::CourtEstablishment < Ecourts::Result
  belongs_to :search, :class_name=>'Ecourts::Search'

  def result
    get_result({:court_code=>court_code})
  end

  def get_request
    get_req_and_parse_captcha({:court_code=>court_code})
  end

end

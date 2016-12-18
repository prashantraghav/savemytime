class Ecourts::CourtEstablishment < Ecourts::Result
  belongs_to :search, :class_name=>'Ecourts::Search'

  def result
    get_result({:court_code=>court_code})
  end

end

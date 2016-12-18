class Ecourts::CourtComplex < Ecourts::Result
  belongs_to :search, :class_name=>"Ecourts::Search"

  def result
    get_result({:court_code_arr=>court_code})
  end
end

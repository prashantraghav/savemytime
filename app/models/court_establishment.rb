class CourtEstablishment < Ecourt
  belongs_to :search

  def result
    get_result({:court_code=>court_code})
  end

end

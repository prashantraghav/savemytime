class CourtComplex < Ecourt
  belongs_to :search

  def result
    get_result({:court_code_arr=>court_code})
  end
end

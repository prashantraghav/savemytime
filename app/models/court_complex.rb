class CourtComplex < Ecourt
  belongs_to :search

  def result
    logger.info("\n\n\n CourtComplext - #{self.inspect} \n\n\n")
    get_result({:court_code_arr=>court_code})
  end
end

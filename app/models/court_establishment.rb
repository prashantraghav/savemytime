class CourtEstablishment < Ecourt
  belongs_to :search

  def result
    logger.info("\n\n\n CourtEstablishment - #{self.inspect} \n\n\n")
    get_result({:court_code=>court_code})
  end

end

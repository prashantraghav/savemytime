module EcourtHelper
  def details_path(court_code, caseno, cino)
    "#{ecourt_details_path}?state_code=#{@state_code}&dist_code=#{@dist_code}&court_code=#{court_code}&caseno=#{caseno}&cino=#{cino}&case_no=#{@search.kase.no}"
  end

  def get_states
    ECOURT_CONFIG_DATA['states']
  end

  def get_state(state_code)
    get_states.select{|s| s['code'] == state_code.to_i}.first
  end

  def get_dist(state_code, dist_code)
    return unless state = get_state(state_code)
    state['dist'].select{|d| d['code'] == dist_code.to_i}.first
  end

end

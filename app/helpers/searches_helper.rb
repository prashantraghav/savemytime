module SearchesHelper

  def get_state(state_code)
    @states.select{|s| s['code'] == state_code.to_i}.first
  end

  def get_dist(state_code, dist_code)
    return unless state = get_state(state_code)
    state['dist'].select{|d| d['code'] == dist_code.to_i}.first
  end

end

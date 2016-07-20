module EcourtHelper
 def details_path(court_code, caseno, cino)
   "#{ecourt_details_path}?state_code=#{@state_code}&dist_code=#{@dist_code}&court_code=#{court_code}&caseno=#{caseno}&cino=#{cino}"
 end
end

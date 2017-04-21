module KasesHelper
  def ecourt_link(kase, search=nil)
    text, path, title = "Search", ecourt_path(:case_no=>kase.no), ''
    if search.present?
      state = ECOURT_CONFIG_DATA['states'].detect{|s| s['code'] == search.params['state_code'].to_i}
      title = "#{state['name']}, #{state['dist'].detect{|d| d['code'] == search.params['dist_code'].to_i}['name']}"
      text = search.status.eql?("completed") ? 'View Result' : search.status
      path = search.status.eql?("completed") ? ecourt_search_results_path(search) : ecourt_test_path(:ecourt_id=>search.id)
    end
    (path.present?) ? link_to(text, path, {:target=>'_blank', :title=>title}) : text
  end

  def supreme_court_link(kase)
    text, path = "Search", supreme_court_case_title_index_path(:case_no=>kase.no)
    if kase.supreme_court_case_title_search.present?
      text = kase.supreme_court_case_title_search.status.eql?("completed") ? 'View Result' : kase.supreme_court_case_title_search.status
      path = kase.supreme_court_case_title_search.status.eql?("completed") ? supreme_court_case_title_search_results_path(kase.supreme_court_case_title_search) : nil
    end
    (path.present?) ? link_to(text, path, {:target=>'_blank'}) : text
  end

  def bombay_high_court_link(kase)
    text, path = "Search", high_courts_bombay_party_wise_index_path(:case_no=>kase.no)
    if kase.high_courts_bombay_party_wise_search.present?
      text = kase.high_courts_bombay_party_wise_search.status.eql?("completed") ? 'View Result' : kase.high_courts_bombay_party_wise_search.status
      path = kase.high_courts_bombay_party_wise_search.status.eql?("completed") ? high_courts_bombay_party_wise_search_results_path(kase.high_courts_bombay_party_wise_search) : nil
    end
    (path.present?) ? link_to(text, path, {:target=>'_blank'}) : text
  end
end

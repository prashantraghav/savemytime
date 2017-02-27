module KasesHelper
  def ecourt_link(kase)
    text, path = "Search", ecourt_path(:case_no=>kase.no)
    if kase.ecourts_search.present?
      text = kase.ecourts_search.status.eql?("completed") ? 'View Result' : kase.ecourts_search.status
      path = kase.ecourts_search.status.eql?("completed") ? ecourt_search_results_path(kase.ecourts_search) : nil
    end
    (path.present?) ? link_to(text, path, {:target=>'_blank'}) : text
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

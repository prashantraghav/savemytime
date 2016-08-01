require 'yaml/store'
require 'nokogiri'
require 'open-uri'
require 'net/http'

uri = URI('http://services.ecourts.gov.in')
get_url = '/ecourtindia/'
post_url = '/ecourtindia/index_qry.php'
get_req = Net::HTTP::Get.new(get_url)

http = Net::HTTP.start(uri.host, uri.port)

get_resp = http.request(get_req)
cookie = get_resp['set-cookie'].split(';')[0]
puts cookie

page = Nokogiri::HTML(get_resp.body)
options = page.css('select#sess_state_code > option')

states = []
options.each_with_index do |op, index|
  next if index == 0
  code = op.to_s.match(/value="(.*?)\~/).to_s.gsub('value="', '').gsub('~', '')
  name = op.to_s.match('(>.*<)').to_s.gsub('>', '').gsub('<', '')
  states << {'code'=>code.to_i, 'name'=>name}
end

__csrf_magic = page.css('input[name="__csrf_magic"]').to_s.match('value=".*?"').to_s.gsub('value="', '').gsub('"', '')

states.each_with_index do |state, index|
  params = {'__csrf_magic'=>__csrf_magic, 'action_code'=>'fillDistrict', 'appFlag'=>'web', 'lang_sel'=>'E', 'lstatelang'=>'Regional Language', 'state_code'=>state['code']}

  post_req = Net::HTTP::Post.new(post_url)
  post_req.add_field('cookie', cookie)
  post_req.add_field('referer', 'http://services.ecourts.gov.in')
  post_req.set_form_data params

  res = http.request post_req
  #res = Net::HTTP.post_form(uri, params)
  states[index]['dist'] =  res.body.split('#').collect { |d| {'code'=>d.split('~')[0].to_i, 'name'=>d.split('~')[1]} unless d.split('~')[1] == 'Select District'}.compact
  states[index]['dist'].each_with_index do |dist, i|
    get = Net::HTTP::Get.new("/ecourtindia/cases/ki_petres.php?state_cd=#{state['code']}&dist_cd=#{dist['code']}&appFlag=web")
    resp = http.request(get)
    page = Nokogiri::HTML(resp.body)
    complex_options = page.css('select#court_complex_code > option')
    est_options = page.css('select#court_code > option')
    
    states[index]['dist'][i]['court_complex'] = []
    complex_options.each_with_index do |op, a|
      next if a == 0
      code = op.to_s.match(/value="(.*?)"/).to_s.gsub('value="', '').gsub('"', '').gsub(/.*?@/, '')
      name = op.to_s.match('(>.*<)').to_s.gsub('>', '').gsub('<', '')
      states[index]['dist'][i]['court_complex'] << {'code'=>code, 'name'=>name}
    end

    states[index]['dist'][i]['court_establishment'] = []
    est_options.each_with_index do |opt, at|
      next if at == 0
      c = opt.to_s.match(/value="(.*?)"/).to_s.gsub('value="', '').gsub('"', '')
      n = opt.to_s.match('(>.*<)').to_s.gsub('>', '').gsub('<', '')
      states[index]['dist'][i]['court_establishment'] << {'code'=>c, 'name'=>n}
    end

  end
end

store = YAML::Store.new "states.yml"
store.transaction do 
  store["states"] = states
end
puts states
#end

#@uri = URI('http://ecourts.gov.in')
#@http = Net::HTTP.start(@uri.host, @uri.port)

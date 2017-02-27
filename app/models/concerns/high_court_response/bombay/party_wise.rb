class HighCourtResponse::Bombay::PartyWise
  extend ActiveSupport::Concern
  attr_accessor :bench, :jurisdiction, :name, :pet_or_res, :year
  
  def initialize(hash={})
    @bench = hash[:bench]
    @jurisdiction = hash[:jurisdiction]
    @name = hash[:name]
    @year = hash[:year]
    @pet_or_res = hash[:pet_or_res]
  end

  def search
    set_url
    get_request
    post_request
  end

  def details(url)
    set_url
    http = Net::HTTP.start(@uri.host, @uri.port)
    req = Net::HTTP::Get.new(@uri.to_s+'/'+url)
    req['user-agent']="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:50.0) Gecko/20100101 Firefox/50.0"
    resp = @http.request(req)
  end

  private

  def set_url
    Rails.logger.info "Setting Bombay High Court URLs - #{Time.now}" unless Rails.env.production?

    @uri = URI('http://bombayhighcourt.nic.in')
    @get_url = "/party_query.php"
    @post_url = "/partyquery_action.php"
  end

  def get_request
    Rails.logger.info "Get Request - #{Time.now}" unless Rails.env.production?

    @http = Net::HTTP.start(@uri.host, @uri.port)
    req = Net::HTTP::Get.new(@uri.to_s+@get_url)
    req['user-agent']="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:50.0) Gecko/20100101 Firefox/50.0"
    @get_resp = @http.request(req)
    @cookie = @get_resp['Set-Cookie'].split(';')[0]
    @get_resp
  end

  def post_request
    Rails.logger.info "Post Request - #{Time.now}" unless Rails.env.production?

    req = Net::HTTP::Post.new(@uri.to_s+@post_url)
    req['user-agent']="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:50.0) Gecko/20100101 Firefox/50.0"
    req.set_form_data(post_params)
    resp = @http.request req

    Rails.logger.info "Post Response Code - #{resp.code} - #{Time.now}" unless Rails.env.production?

    raise ResponseError.new("Failed Response", resp) unless resp.code.to_i == 200 #and resp.body.match(/#{@name}/i)
    resp
  end



  def post_params
    {'m_hc'=>@bench, 'm_party'=>@name, 'm_side'=>@jurisdiction, 'myr'=>@year, 'pageno'=>'1', 'petres'=>@pet_or_res, 'submit1'=>'Submit'}
  end
end

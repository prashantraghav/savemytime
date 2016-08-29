require 'resolv-replace'
require 'tesseract'

class EcourtResponse
  extend ActiveSupport::Concern
  attr_accessor :state_code, :dist_code, :court_code, :court_code_arr, :name, :year, :f

  def initialize(hash = {})
    @court_code = hash[:court_code]
    @court_code_arr = hash[:court_code_arr]
    @state_code = hash[:state_code]
    @dist_code = hash[:dist_code]
    @name = hash[:name]
    @year = hash[:year]
    @f = hash[:f] || 'Both'
  end


  def search
    set_url
    get_request
    parse_captcha
    post_request
  end

  def details(case_no, cino)
    set_url
    get_request
    req = Net::HTTP::Post.new(@post_details_url)
    __csrf_magic = @get_resp.body.match('csrfMagicToken.*?=.*?".*?";').to_s.gsub(/csrfMagicToken.*?=.*?"/, '').gsub('";', '')
    req.add_field('cookie', @cookie)
    req.set_form_data({'__csrf_magic'=>__csrf_magic, 'appFlag'=>'web', 'case_no'=>case_no, 'cino'=>cino, 'court_code'=>@court_code, 'dist_code'=>@dist_code, 'state_code'=>@state_code})
    resp = @http.request req
    resp
  end

  private

  def set_url
    Rails.logger.info "Setting Ecourt URLs - #{Time.now}" unless Rails.env.production?

    @uri = URI('http://services.ecourts.gov.in')
    @get_url = "/ecourtindia/cases/ki_petres.php?state_cd=#{@state_code}&dist_cd=#{@dist_code}&appFlag=web"
    @captcha_url = "/ecourtindia/cases/image_captcha.php"
    @post_url = "/ecourtindia/cases/ki_petres_qry.php"
    @post_details_url = "/ecourtindia/cases/o_civil_case_history.php"
  end

  def get_request
    Rails.logger.info "Get Request - #{Time.now}" unless Rails.env.production?

    @http = Net::HTTP.start(@uri.host, @uri.port)
    @get_resp = @http.request_get @get_url
    @cookie = @get_resp['set-cookie'].split(';')[0]
  end

  def parse_captcha
    Rails.logger.info "Parsing Captcha - #{Time.now}" unless Rails.env.production?

    local_captcha_path = "#{Rails.root}/public/ecourt/captcha.png"
    req = Net::HTTP::Get.new(@captcha_url)
    req.add_field('cookie', @cookie)
    resp = @http.request req
    File.open(local_captcha_path, 'wb'){|f| f.write(resp.body)}
    
    e = Tesseract::Engine.new {|e|
      e.language = :eng
      e.blacklist = '|'
    }

    @captcha = e.text_for(local_captcha_path).strip
  end


  def post_request
    Rails.logger.info "Post Request - #{Time.now}" unless Rails.env.production?

    req = Net::HTTP::Post.new(@post_url)
    req.add_field('cookie', @cookie)
    req.set_form_data(post_params)
    resp = @http.request req

    Rails.logger.info "Post Response Code - #{resp.code} - #{Time.now}" unless Rails.env.production?

    raise EcourtResponseError.new("Failed Response", resp) unless resp.code.to_i == 200 and resp.body.match(/#{@name}/i)
    resp
  end

  def post_params
    para = {'action_code'=>'showRecords', 'captcha'=>@captcha.to_s, 'state_code'=>@state_code, 'dist_code'=>@dist_code, 'petres_name'=>name, 'rgyear'=>@year, 'f'=>@f }
    para['court_code']=@court_code if @court_code
    para['court_codeArr']=@court_code_arr if @court_code_arr
    return para
  end

end

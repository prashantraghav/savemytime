require 'resolv-replace'
require 'tesseract'
class Ecourt
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


  def get_result
    set_url
    get_request
    parse_captcha
    post_request
  end

  def get_details
    set_url
    get_request
    req = Net::HTTP::Post.new(@post_details_url)
    __csrf_magic = @get_resp.body.match('csrfMagicToken.*?=.*?".*?";').to_s.gsub(/csrfMagicToken.*?=.*?"/, '').gsub('";', '')
    req.add_field('cookie', @cookie)
    req.set_form_data({'__csrf_magic'=>__csrf_magic, 'appFlag'=>'web', 'case_no'=>'205101400102010', 'cino'=>'MHMT010000522010', 'court_code'=>'1', 'dist_code'=>'39', 'state_code'=>'1'})
    resp = @http.request req
    resp.body
  end

  private

  def set_url
    @uri = URI('http://ecourts.gov.in')
    @get_url = "/services/cases/ki_petres.php?state_cd=#{@state_code}&dist_cd=#{@dist_code}&appFlag=web"
    @captcha_url = "/services/cases/image_captcha.php"
    @post_url = "/services/cases/ki_petres_qry.php"
    @post_details_url = "/services/cases/o_civil_case_history.php"
  end

  def get_request
    @http = Net::HTTP.start(@uri.host, @uri.port)
    @get_resp = @http.request_get @get_url
    @cookie = @get_resp['set-cookie'].split(';')[0]
  end

  def parse_captcha
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
    req = Net::HTTP::Post.new(@post_url)
    req.add_field('cookie', @cookie)
    req.set_form_data(post_params)
    resp = @http.request req
    resp.body
  end

  def post_params
    para = {'action_code'=>'showRecords', 'captcha'=>@captcha.to_s, 'state_code'=>@state_code, 'dist_code'=>@dist_code, 'petres_name'=>name, 'rgyear'=>@year, 'f'=>@f }
    para['court_code']=@court_code if @court_code
    para['court_codeArr']=@court_code_arr if @court_code_arr
    return para
  end

end

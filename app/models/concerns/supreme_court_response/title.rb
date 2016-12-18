module SupremeCourtResponse
  class Title

    def initialize(hash={})
      @title=hash[:title]
      @year=hash[:year]
    end

    def search
      set_url
      get_request
      post_request
    end

    def details(listcause)
      set_url
      get_request
      req = Net::HTTP::Post.new(@post_details_url)
      details_params = {'listcause'=>listcause, 'submit1'=>'Submit'}
      req.set_form_data(details_params)
      resp = @http.request req
    end

    private

    def set_url
      Rails.logger.info "Setting Supreme court URLs - #{Time.now}" unless Rails.env.production?
      @uri = URI('http://courtnic.nic.in')
      @get_url = '/supremecourt/causetitle.asp'
      @post_url = '/supremecourt/qrycause.asp'
      @post_details_url = '/supremecourt/causedisp.asp'
    end

    def get_request
      Rails.logger.info "Get Request - #{Time.now}" unless Rails.env.production?
      @http = Net::HTTP.start(@uri.host, @uri.port)
      @get_resp = @http.request_get @get_url
    end

    def post_request
      Rails.logger.info "Post Request - #{Time.now}" unless Rails.env.production?
      req = Net::HTTP::Post.new(@post_url)
      req.set_form_data(post_params)
      resp = @http.request req
      Rails.logger.info "Post Response Code - #{resp.code} - #{Time.now}" unless Rails.env.production?
      raise SupremeCourtResponse::Error.new("Failed Response", resp) unless resp.code.to_i == 200
      resp
    end

    def post_params
      {'txttitle'=>@title, 'seltitleyear'=>@year, 'seltitletype'=>'3', 'button'=>'Submit'}
    end
  end
end

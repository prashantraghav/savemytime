module SupremeCourtResponse
  class CaseNumber

    def initialize(hash={})
      @case_type=hash[:case_type]
      @case_number=hash[:case_number]
      @year=hash[:year]
    end

    def search
      set_url
      get_request
      post_request
    end

    private

    def set_url
      Rails.logger.info "Setting Supreme Court URLs - #{Time.now}" unless Rails.env.production?

      @uri = URI('http://courtnic.nic.in')
      @get_url = '/supremecourt/caseno.asp'
      @post_url = '/supremecourt/querycheck.asp'
    end

    def get_request
      Rails.logger.info "Get Request - #{Time.now}" unless Rails.env.production?

      @http = Net::HTTP.start(@uri.host, @uri.port)
      @get_resp = @http.request_get @get_url
      @cookie = @get_resp['set-cookie'].split(';')[0]
    end

    def post_request
      Rails.logger.info "Post Request - #{Time.now}" unless Rails.env.production?

      req = Net::HTTP::Post.new(@post_url)
      req.add_field('cookie', @cookie)
      req.set_form_data(post_params)
      resp = @http.request req

      Rails.logger.info "Post Response Code - #{resp.code} - #{Time.now}" unless Rails.env.production?
      raise SupremeCourtResponse::Error.new("Failed Response", resp) unless resp.code.to_i == 200
      resp
    end

    def post_params
      {'seltype'=>@case_type, 'selcyear'=>@year, 'txtnumber'=>@case_number, 'Search'=>'Submit'}
    end
  end

end

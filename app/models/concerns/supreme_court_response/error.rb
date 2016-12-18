class SupremeCourtResponse::Error < StandardError
  attr_reader :response

  def initialize(msg="Error occurred.", resp)
    @response = resp
    Rails.logger.info("#{self.inspect} with response #{resp.inspect}")
    super(msg)
  end

end

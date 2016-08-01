class EcourtResponseError < StandardError
  attr_reader :code, :body
  def initialize(msg="Error occurred.", code, body)
    @code , @body = code, body
    super(msg)
  end
end

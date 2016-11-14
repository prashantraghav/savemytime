SearchJob = Struct.new(:id) do
  def perform
    Search.unscoped.find(id).get_result
  end
end

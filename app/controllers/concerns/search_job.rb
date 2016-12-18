SearchJob = Struct.new(:klass, :id) do
  def perform
    klass.unscoped.find(id).get_result
  end
end

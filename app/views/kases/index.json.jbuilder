json.array!(@kases) do |kase|
  json.extract! kase, :id, :no, :name, :from_year, :to_year
  json.url kase_url(kase, format: :json)
end

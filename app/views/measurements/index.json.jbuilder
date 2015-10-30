json.array!(@measurements) do |measurement|
  json.extract! measurement, :id, :name, :value
  json.url measurement_url(measurement, format: :json)
end

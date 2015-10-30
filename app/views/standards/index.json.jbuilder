json.array!(@standards) do |standard|
  json.extract! standard, :id, :index, :machine_id, :um, :per_hour, :waste
  json.url standard_url(standard, format: :json)
end

json.array!(@days) do |day|
  json.extract! day, :id, :machine_id, :day, :shifts, :hours, :busy, :available
  json.url day_url(day, format: :json)
end

json.array!(@routes) do |route|
  json.extract! route, :id, :number, :waste
  json.url route_url(route, format: :json)
end

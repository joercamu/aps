json.array!(@modifications) do |modification|
  json.extract! modification, :id, :order_id, :priority, :type, :body, :user_id, :state
  json.url modification_url(modification, format: :json)
end

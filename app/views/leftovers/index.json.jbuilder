json.array!(@leftovers) do |leftover|
  json.extract! leftover, :id, :quantity, :um, :weight, :location, :order_origin, :sheet_id, :sheet_version, :entry_date, :disposition, :sheet_composite, :place_origin, :state
  json.url leftover_url(leftover, format: :json)
end

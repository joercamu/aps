json.array!(@leftovers) do |leftover|
  json.extract! leftover, :id, :quantity, :quantity_available, :um, :weight, :location, :order_origin, :sheet_id, :sheet_code, :sheet_version, :entry_date, :disposition, :sheet_composite, :place_origin, :state
  json.url leftover_url(leftover, format: :json)
end

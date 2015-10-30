json.array!(@orders) do |order|
  json.extract! order, :id, :state, :weight, :repeat, :route_id, :scheduled_meters, :date_offer, :outsourced_id, :outsourced_name, :outsourced_tolerance_down, :outsourced_tolerance_up, :order_date_request, :order_number, :order_quantity, :order_type, :order_um, :order_unit_value, :sheet_caliber, :sheet_client, :sheet_composite, :sheet_cut_type, :sheet_film, :sheet_guillotine, :sheet_height, :sheet_height_planned, :sheet_id, :sheet_meters_roll, :sheet_number, :sheet_print, :sheet_product_type, :sheet_route, :sheet_spaces, :sheet_version, :sheet_width
  json.url order_url(order, format: :json)
end

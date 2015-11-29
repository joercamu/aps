json.extract! @order, :id, :state, :weight, :repeat, :route_id, :scheduled_meters, :date_offer, :outsourced_id, :outsourced_name, :outsourced_tolerance_down, :outsourced_tolerance_up, :order_date_request, :order_number, :order_quantity, :order_type, :order_um, :order_unit_value, :sheet_caliber, :sheet_client, :sheet_composite, :sheet_cut_type, :sheet_film, :sheet_guillotine, :sheet_height, :sheet_height_planned, :sheet_id, :sheet_meters_roll, :sheet_number, :sheet_print, :sheet_product_type, :sheet_route, :sheet_spaces, :sheet_version, :sheet_width, :created_at, :updated_at
json.subprocesses @order.subprocesses do |subprocess|
	json.extract! subprocess, :id, :order_id, :procedure_id, :standard_id, :minutes, :start_date, :end_date, :meter, :sequence, :state, :created_at, :updated_at,:setup_time,:day_id
	json.order subprocess.order.order_number
	json.procedure subprocess.procedure.name
	json.machine subprocess.standard.machine.name
	json.standard subprocess.standard.index
	json.standard_um subprocess.standard.um
	json.days subprocess.standard.machine.days.availables.where('available >= ?',subprocess.minutes) do |day|
		json.id day.id
		json.day day.day
		json.available day.available
	end
end
json.leftovers @order.has_leftovers do |leftover|
	json.extract! leftover, :leftover_id, :order_id, :quantity
	json.sheet_code leftover.leftover.sheet_code
end
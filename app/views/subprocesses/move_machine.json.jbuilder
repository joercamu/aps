json.extract! @subprocess, :id, :order_id, :procedure_id, :standard_id, :minutes, :start_date, :end_date, :meter, :sequence, :state, :created_at, :updated_at, :setup_time, :day_id
json.machine do
	json.name @machine.name
	json.standard @machine.standards.first.id
end
json.errors @machine.errors
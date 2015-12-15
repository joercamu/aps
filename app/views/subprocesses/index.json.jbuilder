json.array!(@subprocesses) do |subprocess|
  json.extract! subprocess, :id, :order_id, :procedure_id, :standard_id, :minutes, :start_date, :end_date, :meter, :sequence, :state, :quantity_finished
  json.url subprocess_url(subprocess, format: :json)
  json.order subprocess.order
  json.machine_id subprocess.standard.machine.id
end

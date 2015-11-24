json.array!(@subprocesses) do |subprocess|
  json.extract! subprocess, :id, :order_id, :procedure_id, :standard_id, :minutes, :start_date, :end_date, :meter, :sequence, :state
  json.url subprocess_url(subprocess, format: :json)
end

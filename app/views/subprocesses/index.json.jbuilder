json.array!(@subprocesses) do |subprocess|
  json.extract! subprocess, :id, :order, :procedure, :standard, :minutes, :start_date, :endtime, :meters, :sequence, :state
  json.url subprocess_url(subprocess, format: :json)
end

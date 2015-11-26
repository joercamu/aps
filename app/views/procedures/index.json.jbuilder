json.array!(@procedures) do |procedure|
  json.extract! procedure, :id, :name, :press
  json.url procedure_url(procedure, format: :json)
  json.machines procedure.machines do |machine|
  	json.extract! machine, :id, :name, :press
  end
end

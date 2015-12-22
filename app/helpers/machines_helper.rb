module MachinesHelper
# segun el estado enviar un stilo de border con un color
	def status_subprocess (state, quantity)
		if state == "terminado"
			"border-left: 5px solid #43AC6A;"
		elsif state != "terminado" && quantity > 0
			"border-left: 5px solid #008CBA;"
		else
			"border-left: 5px solid #EEEEEE;"
		end
		
	end
end

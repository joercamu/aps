$ ->
	myspin = {
		opts : {
			lines: 13 # The number of lines to draw
			length: 28 # The length of each line
			width: 14 # The line thickness
			radius: 42 # The radius of the inner circle
			scale: 1 # Scales overall size of the spinner
			corners: 1 # Corner roundness (0..1)
			color: '#000' # #rgb or #rrggbb or array of colors
			opacity: 0.25 # Opacity of the lines
			rotate: 42 # The rotation offset
			direction: 1 # 1: clockwise -1: counterclockwise
			speed: 1 # Rounds per second
			trail: 60 # Afterglow percentage
			fps: 20 # Frames per second when using setTimeout() as a fallback for CSS
			zIndex: 2e9 # The z-index (defaults to 2000000000)
			className: 'spinner' # The CSS class to assign to the spinner
			top: '50%' # Top position relative to parent
			left: '50%' # Left position relative to parent
			shadow: false # Whether to render a shadow
			hwaccel: false # Whether to use hardware acceleration
			position: 'absolute' # Element positioning
		}
		create:->
			target = document.getElementById('foo')
			@spinner = new Spinner(@opts).spin(target)
		remove:->
			@spinner.stop()
	}
	order = {
		orders : []
		get:->
			$.ajax
				url: 'http://192.168.1.247/api_khronos/index.php/orders/get'
				type: 'get'
				dataType: 'json'
				beforeSend:->
					myspin.create()
				success: (data)->
					myspin.remove()
					order.orders = data
					if data.length > 0
						if confirm("Se encontraron #{data.length} resultados, ¿Desear traerlos?")
							index = 0
							for item in order.orders
								$('#tfoot_orders').append(order.buildHtml(item,index,"schedule"))
								index++
								# order.create(item)
							order.addEventSchedule()
					else
						alert("No se encontraron resultado")
				error: (error) ->
					myspin.remove()
					console.log(error)
					alert("Upps tenemos un error, por favor refreca la pagina, si persiste avisa al administrador")
		create:(item,index)->
			# item = {"state":"aprobado","weight":0.0,"repeat":1,"route_id":43,"scheduled_meters":0,"date_offer":"2015-10-28","outsourced_id":900041914,"outsourced_name":"AVON COLOMBIA SAS","outsourced_tolerance_down":5,"outsourced_tolerance_up":5,"order_date_request":"2015-10-28","order_number":27091,"order_quantity":4.0,"order_type":"RE","order_um":"ROL","order_unit_value":19.47,"sheet_caliber":40.0,"sheet_client":649,"sheet_composite":"MET","sheet_cut_type":"","sheet_film":"PET","sheet_guillotine":0.0,"sheet_height":91.0,"sheet_height_planned":91.0,"sheet_id":91193,"sheet_meters_roll":500.0,"sheet_number":649,"sheet_print":true,"sheet_product_type":"MAET","sheet_route":"2-SLITER 1,3-p5,10-SLITER 3,4-PEGADORA 1,11-CAV 6","sheet_spaces":4,"sheet_version":5,"sheet_width":27.0}
			$.ajax
				url: '/orders.json'
				type: 'post'
				contentType: 'application/json'
				dataType: 'json'
				data:JSON.stringify(item)
				success:(data)->
					console.log(data)
					$("#row#{index}").remove()
					$('#tbody_orders').append(order.buildHtml(data,data.id,"alert"))
				error: (error)->
					console.log(error)
		buildHtml:(order,index,nameclass)->
			#nameclass es la clase que se le aplica al button dependiendo de ella cambioa de color y realiza diferentes acciones
			if nameclass == "alert"
				textbutton = "Eliminar"
			else
				textbutton = "Activar"

			html = "<tr id='row#{index}'>
		        <td>#{ order.order_number }</td>
		        <td>#{ order.order_type }</td>
		        <td>#{ order.sheet_client}-#{order.sheet_number}</td>
		        <td>#{ order.outsourced_name }</td>
		        <td>#{ order.order_quantity }</td>
		        <td>#{ order.order_um }</td>
		        <td>#{ order.order_unit_value }</td>
		        <td>#{ order.order_date_request }</td>
		        <td><button class='#{nameclass} button' item='#{index}'>#{textbutton}</button></td>
		    </tr>"
		addEventSchedule:->
			$('.schedule').click ->
				#this = button "Programar"
				item = order.orders[$(this).attr("item")]#obtengo el objeto en el arreglo
				order.create(item,$(this).attr("item"))
	}
	$('#get_orders').click ->
		order.get()
		
	
		

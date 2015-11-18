$ ->
	order = {
		orders : []
		get:->
			$.ajax
				url: 'http://localhost/api_khronos/index.php/orders/get'
				type: 'get'
				dataType: 'json'
				success: (data)->
					@orders = data
					for item in @orders
						order.create(item)
				error: (error) ->
					console.log(error)
		create:(item)->
			# item = {"state":"aprobado","weight":0.0,"repeat":1,"route_id":43,"scheduled_meters":0,"date_offer":"2015-10-28","outsourced_id":900041914,"outsourced_name":"AVON COLOMBIA SAS","outsourced_tolerance_down":5,"outsourced_tolerance_up":5,"order_date_request":"2015-10-28","order_number":27091,"order_quantity":4.0,"order_type":"RE","order_um":"ROL","order_unit_value":19.47,"sheet_caliber":40.0,"sheet_client":649,"sheet_composite":"MET","sheet_cut_type":"","sheet_film":"PET","sheet_guillotine":0.0,"sheet_height":91.0,"sheet_height_planned":91.0,"sheet_id":91193,"sheet_meters_roll":500.0,"sheet_number":649,"sheet_print":true,"sheet_product_type":"MAET","sheet_route":"2-SLITER 1,3-p5,10-SLITER 3,4-PEGADORA 1,11-CAV 6","sheet_spaces":4,"sheet_version":5,"sheet_width":27.0}
			$.ajax
				url: '/orders.json'
				type: 'post'
				contentType: 'application/json'
				dataType: 'json'
				data:JSON.stringify(item)
				success:(data)->
					console.log(data)
				error: (error)->
					console.log(error)
	}
	$('#get_orders').click ->
		order.get()
	$('#new_order').submit (e)->
		console.log(e)
		console.log($(this).serialize())
		e.preventDefault()
		

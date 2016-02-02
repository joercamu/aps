var app = angular.module("apsApp", ["ngResource"])
app.factory("apiKhronos",function(){
	return "192.168.1.79";
});
app.factory("spin",function(){
	return myspin = {
      opts: {
        lines: 13,
        length: 28,
        width: 14,
        radius: 42,
        scale: 1,
        corners: 1,
        color: '#000',
        opacity: 0.25,
        rotate: 42,
        direction: 1,
        speed: 1,
        trail: 60,
        fps: 20,
        zIndex: 2e9,
        className: 'spinner',
        top: '50%',
        left: '50%',
        shadow: false,
        hwaccel: false,
        position: 'absolute'
      },
      create: function() {
        var target;
        target = document.getElementById('foo');
        return this.spinner = new Spinner(this.opts).spin(target);
      },
      remove: function() {
        return this.spinner.stop();
      }
    };
});
app.controller('getOrdersController',['$scope','$resource','apiKhronos','spin',function($scope,$resource,apiKhronos,spin){
	Orders = $resource("/orders/:id.json",{id:"@id"},{update: {method: 'PUT'} });
	OrdersKhronos = $resource("http://"+apiKhronos+"/api_khronos/index.php/orders/get/:id",{id:"@id"},{update: {method: 'PUT'} });
	$scope.orders = [];
	$scope.order_number;
	$scope.getOrders = function(){
		spin.create();
		OrdersKhronos.query(function(response){
			spin.remove();
			console.log(response);
			$scope.orders = response;
			if ($scope.orders.length == 0){
				alert("No se encontraron resultados");
			}
		});
	};
	$scope.getOrder = function(){
		spin.create();
		OrdersKhronos.query({id:$scope.order_number},function(response){
			spin.remove();
			console.log(response);
			$scope.orders = response;
			if ($scope.orders.length == 0){
				alert("No se encontraron resultados");
			}
		});
	};
	$scope.createOrder = function(order){
		spin.create();
		console.log(order);
		Orders.save(order,function(response){
			spin.remove();
			$scope.orders = $scope.orders.filter(function(element){
				return parseInt(element.order_number) != response.order_number
			});
			console.log(response);
		},function(error){
			spin.remove();
			console.log(error);
			alert(error);
		});
	}
}]);
// quite $routeParams en 'OrdersController' y 'ngRoute' en dependencias
app.controller('OrdersController',['$scope','$resource','$http','spin','apiKhronos',function($scope,$resource,$http,spin,apiKhronos){
	$scope.errors = [];//array errors subprocesses

	$scope.quantity_at_calculate = 0;//quantiyy of order - leftovers

	$scope.state_programmed = false;//boolean for show or hide form "meters_programed"
	$scope.state_leftovers = false;//boolean gor shoe or hide form "consult leftovers"
	$scope.state_route = false;//boolean for show or hide form "meters_programed"
	$scope.state_subprocesses = false;//boolean gor shoe or hide form "consult leftovers"
	//array with object for save order_leftovers
	$scope.order_leftovers = [];//registros a guardar
	$scope.new_order_leftover = {};//new record
	$scope.new_order_leftover_index = 1;//index each record

	$scope.routes = [];
	$scope.new_route = {};
	$scope.machines = [];
	$scope.routesGenerated = false;

	$(document).on("ajax:success","form#form-comments",function(ev,data){
		$scope.order.comments.push(data);
		console.log(data);
		console.log($scope.order.comments);
		$scope.$apply(function(){
			$('#form-comments').trigger("reset");
		});

	});

	$scope.validateReady = function(){
		if ($scope.state_programmed && $scope.state_route && $scope.state_leftovers && $scope.state_subprocesses){
			return true;
		}
	};

	// orders, pedidos
	Orders = $resource("/orders/:id.json",{id:"@id"},{update: {method: 'PUT'} });
	// days, dias
	Days = $resource("/days.json");
	// Leftover, sobrantes /leftovers/by_sheet/:id.json
	Leftovers = $resource("/leftovers/by_sheet/:sheet_id.json",{sheet_id:"@sheet_id"});
	// Calculate meters
	Calculate_meters = $resource('/calculate_meters.json',{id:"@id",quantity:"@quantity"});
	// Procesos generles
	Procedures = $resource('/procedures.json');
	// Subprocesses
	Subprocesses = $resource("/subprocesses/:id.json",{id:"@id"},{update: {method: 'PUT'} });
	// API khronos
	OrdersKhronos = $resource("http://"+apiKhronos+"/api_khronos/index.php/orders/get/:id",{id:"@id"},{update: {method: 'PUT'} });
	
	$scope.orders = Orders.query();

	//
	$scope.updateOrderOrigin = function(){
		orderOriginal = {};
		console.log($scope.order.order_number);
		spin.create();
		OrdersKhronos.query({id:$scope.order.order_number},function(response){
			if (response[0]){
				Orders.update({id:$scope.order.id},response[0],function(){
					spin.remove();
					console.log(response);
					window.location.href = '/orders/'+$scope.order.id+'/reactivate';
				});	
			}else{
				spin.remove();
				alert("No se encontro el pedido...");
			}
			
		});	
	};
	//consult procesos and machines references
	$scope.getProcedures = function(callback){
		$scope.procedures = Procedures.query(function(response){
			response[2].machines.forEach(function(machine){
				$scope.machines[machine.press] = machine.name;
			});
			console.log($scope.machines);

		});
	callback();
	};
	//trigger chenge machine or procedure
	$scope.swRoutesGenerated = function(){
		$scope.routesGenerated = false;
	};

	//consult days available
	$scope.days = Days.query(function(response){
		console.log(response);
	});
	$scope.structureRoutes = function(){
		$scope.routes = [];
		$scope.order.sheet_route.split(",").forEach(function(element){
			object = element.split("-");
			$scope.new_route.procedure = parseInt(object[0]);
			if (parseInt(object[0]) == 3){
				// validacion que se debe hacer cuando se modifica la ruta por segunda vez, ya que las maquinas ya no tendrian press, sino name como clave
				if(typeof $scope.machines[object[1]] != "undefined"){
					$scope.new_route.machine = $scope.machines[object[1]];
				}else{//si es la segunda vez, (aplica solo para "prensa")
					$scope.new_route.machine = object[1]
				}
			}else{
				$scope.new_route.machine = object[1];
			}
			
			$scope.routes.push($scope.new_route);
			$scope.new_route = {};
		});
		console.log($scope.routes);
	};
	$scope.generateRoutes = function(){
		$scope.order.sheet_route = '';
		$scope.routes.forEach(function(element){
			$scope.order.sheet_route = $scope.order.sheet_route + element.procedure + '-' + element.machine+ ',';
		});
		$scope.order.sheet_route = $scope.order.sheet_route.slice(0, -1);
		$scope.routesGenerated = true;
	};
	$scope.saveRoutes = function(){
		$scope.updateOrder();
		$scope.state_route = true;
	};
	
	//consult order
	order_id = $('#IdOrder').val();
	$scope.getOrder = function(){
		$scope.order = Orders.get({id:order_id},function(response){
			//actualizo el dato enviado por el backend "sugerido segun formula @order.calculate_meters"
			// $scope.order.scheduled_meters = $('#input_scheduled_meters').val();
			console.log(response);
			$scope.getLeftovers($scope.order.sheet_id);//consult leftovers references order
			$scope.calculateQuantity();
			$scope.structureRoutes();
		});
	};
	// funcion que actualizar los metros programados
	$scope.updateOrder = function(){
		Orders.update({id:order_id},$scope.order,function(response){
			console.log(response);
		});
	};
	$scope.calculateQuantity = function(){
		quantity_leftovers = 0;
		for (var i = 0; i < $scope.order.leftovers.length; i++) {
			quantity_leftovers = quantity_leftovers + $scope.order.leftovers[i].quantity;
		};
		$scope.quantity_at_calculate = $scope.order.order_quantity - quantity_leftovers;
	};
	$scope.calculateScheduleMeters = function(){
		// orders/:id/calculate_meters/:quantity
		Calculate_meters.save({id:$scope.order.id,quantity:$scope.quantity_at_calculate},function(response){
			$scope.order.scheduled_meters = response.meters;
		});

		//$scope.order.scheduled_meters = calculate_meters.meters;
		//$scope.order.scheduled_meters = $scope.quantity_at_calculate;
	};
	$scope.saveScheduleMeters = function(){
		$scope.updateOrder();
		$scope.state_programmed = true;
	};
	//consult leftovers
	$scope.getLeftovers = function(sheet_id){
		$scope.leftovers = Leftovers.query({sheet_id:sheet_id},function(response){
			console.log(response);
		});		
	};

	// function for add order_leftovers 
	$scope.addHasLeftovers = function(leftover_id,sheet_code, leftover){
		$scope.new_order_leftover.leftover_id = leftover_id;
		$scope.new_order_leftover.order_id = order_id;
		$scope.new_order_leftover.sheet_code = sheet_code;//info
		// $scope.new_order_leftover.quantity = // from view
		for (var i = 0; i < $scope.leftovers.length; i++) {//each leftover
			if ($scope.leftovers[i].id == leftover.id && $scope.new_order_leftover.quantity){
				if ( $scope.leftovers[i].quantity_available >= $scope.new_order_leftover.quantity){
					$scope.new_order_leftover.index = $scope.new_order_leftover_index++;//increase index
					$scope.order_leftovers.push($scope.new_order_leftover);//add object at array
					$scope.leftovers[i].quantity_available = $scope.leftovers[i].quantity_available - $scope.new_order_leftover.quantity;
					$scope.new_order_leftover = {};//empty object
					console.log($scope.order_leftovers);	
				}else{
					alert("No hay disponible");
				}
				
			}
		};
		
	};
	//
	$scope.removeHasLeftovers = function(element_at_remove,leftover_id){
		quantity_element_at_remove = 0;
		$scope.order_leftovers = $scope.order_leftovers.filter(function(element){
			if (element.index == element_at_remove){
				quantity_element_at_remove = element.quantity;//capture quantity of element will be remover
			}
			return element.index != element_at_remove;//condicion of "filter"
		});
		for (var i = 0; i < $scope.leftovers.length; i++) {//each leftover
			if ($scope.leftovers[i].id == leftover_id){
				//increase quantity_available in leftover
				$scope.leftovers[i].quantity_available = $scope.leftovers[i].quantity_available + quantity_element_at_remove;
			}
		}
	};
	//guardar en la base de datos
	$scope.saveHasLeftovers = function(){
		HasLeftovers = $resource('/has_leftovers/:id.json',{id:"@id"});
		for (var i = 0; i < $scope.order_leftovers.length; i++) {
			HasLeftovers.save($scope.order_leftovers[i],function(response){
				console.log(response);
				$scope.getOrder();
			});
		};
		if ($scope.order_leftovers.length == 0){
			alert("No se relacionaron sobrantes");	
		}
		$scope.order_leftovers = [];
		$scope.state_leftovers = true;
	};
	//funcion que envia la SEÑAL para que se creen las rutas
	$scope.submitSubprocesses = function(){
		NewSubprocess = $resource('/new_subprocesses/:id.json',{id:"@id"});
		NewSubprocess.get({id:order_id},function(response){
			console.log(response);
			if (response.errors){
				$scope.errors = response.errors;
				alert("Upps, tenemos problemas...");
			}else{
				$scope.errors = [];
				$scope.order = response;
			}
		});
	};
	//funcion que actualiza todos los subprocesos
	$scope.updateSubprocesses = function(){
		for (var i = 0; i < $scope.order.subprocesses.length; i++) {
			Subprocesses.update({id:$scope.order.subprocesses[i].id},$scope.order.subprocesses[i],function(response){
				// console.log(response)
				$scope.state_subprocesses = true;
			});
		};
	};
	$scope.approveOrder = function(){
		ApproveOrder = $resource('/approve_order/:id.json',{id:"@id"});
		ApproveOrder.get({id: $scope.order.id},
			function(data){
				if (data.state == "ok"){
					alert("Pedido programado correctamente");
					location.href = '/orders/'+$scope.order.id;
				}
				$scope.errors = data.errors;
				console.log(data);
			},
			function(response){
				console.log(response);
			}
		);
	};
	//get process and machines, callback geOrder
	if (order_id){
		$scope.getProcedures($scope.getOrder);
	}
	
}]);
app.controller("leftoversController",['$scope','$resource','apiKhronos','spin',function($scope,$resource,apiKhronos,spin){
	$scope.leftover = {};
	infoLeftovers = $resource('http://'+apiKhronos+'/api_khronos/index.php/orders/get_orders_sheet/:id',{id:"@id"});
	$scope.get = function(){
		spin.create();
		console.log("Consultando...");
		$scope.leftover = infoLeftovers.get({id:$scope.leftover.order_origin},function(){
			if (typeof $scope.leftover.order_origin != "undefined"){
				$('#leftover_order_origin').attr('readonly',true);
				spin.remove();
				$('#leftover_quantity').focus();
				
			}else{
				spin.remove();
				alert("Parece que hay un error, llama al admin! :)");
			}
				
		});
	};
			
}]);
app.controller("machinesController",['$scope','$resource','spin','$http',function($scope,$resource,spin,$http){
	Subprocesses = $resource("/subprocesses/:id.json",{id:"@id"},{update: {method: 'PUT'} });
	// Days = $resource("/days/:id.json",{id:"@id"},{update: {method: 'PUT'} });
	$scope.getSubprocesses = function () {
		spin.create();
		Subprocesses_by_machine = $resource("/subprocesses_machine/:id.json",{id:"@id"},{update: {method: 'PUT'} });
		$scope.subprocesses = Subprocesses_by_machine.query({id:parseInt($('#id_machine').val())},function(){
			spin.remove();
			// $scope.subprocesses = $scope.subprocesses.filter(function(element){
			// 	return element.machine_id == parseInt($('#id_machine').val()) && element.state == "programado";
			// });
		},function(error){
			spin.remove();
			console.log(error);
		});
	};
	$scope.subprocessesToMove = [];
	$scope.subprocessesErrors = [];
	$scope.targetMachine;
	$scope.collectSubprocessesToMove = function() {
		$scope.subprocessesToMove = [];
		$('#item-helper-clipboard').find('dd').each(function(){
			subprocess = {};
			item = $('#'+$(this).attr('id').replace('c',''));
			subprocess.id = item.attr('id').replace('item_','');
			subprocess.name = item.find('table tr td:nth-child(2)').text();
			$scope.subprocessesToMove.push(subprocess);
		});
		
	};
	$scope.moveSubprocesses = function(form){
		moveSubprocesses = $resource('/subprocesses/:id/move_machine/:machine_id.json',{id:"@id",machine_id:"@machine_id"},{update: {method:'PUT'}});
		if(form.tMachine.$touched){
			$('#item-helper-clipboard').remove();
			countSubprocessesToMove = $scope.subprocessesToMove.length;
			countSubprocessesMoved = 0;
			console.log(countSubprocessesToMove);
			$scope.subprocessesToMove.forEach(function(element){
				moveSubprocesses.update({id:element.id,machine_id:form.tMachine.$modelValue},function(resp){
					console.log(resp);
					$scope.subprocessesErrors = resp.errors.status;
					if(!resp.errors.status){//si no hay errores
						$('#formMoveSubprocess').find('button')
						.text("Moviendo...")
						.addClass("disabled");
						console.log('Subproceso cambiado de maquina correctamente');
						$('#item_'+resp.id).remove();
						countSubprocessesMoved = countSubprocessesMoved + 1;
						if(countSubprocessesToMove == countSubprocessesMoved){
							$('#modalChangeMachine').foundation('reveal', 'close');//cerrar modal	
							$('#formMoveSubprocess').find('button')
							.text("Cambiar de maquina")
							.removeClass("disabled");
						}
					}
				});
			});
			
		}
	};

	$scope.validateQuantityMissing = function(repeat) {
		if(repeat > 1){
			return "(SALDO "+(repeat-1)+")";
		}
	};
	$scope.saveQuantityFinished = function (subprocess){
		spin.create();//show loading....
		Subprocesses.update({id:subprocess.id},subprocess,function(response){
						console.log(response);
						subprocess.sw = true;
						spin.remove();//hide loading....
					},function(error){
						alert(error.statusText);
						spin.remove();//hide loading....
					});
	};
	$scope.saveChanges = function(saveType){//function of "sorting" 2 clicks
	
		// var arrs = $('#sortable12').sortable('toArray');
		// console.log(arrs.length);
		if (saveType == "all"){//si se ordenar guardar todos los elementos
			items_to_save = '.sortable:not(#clipboard)';
		}else{
			items_to_save = '.sortable[modified=true]:not(#clipboard)';
		}
		countSubprocesses = 0;
		countSubprocessesUpdated = 0;
		
		console.log($(items_to_save).length);
		if($(items_to_save).length > 0){
			$('#ModalProgressUpdatingSubprocesses').foundation('reveal', 'open');
			$(items_to_save).each(function(){//cada dia
				day = $(this).sortable('toArray');
				dayElement = this;
				countSubprocesses += day.length;
				$(dayElement).attr('modified',false);

				if (day.length > 0){//si el dia tiene pedidos(subprocesos)
					day.forEach(function(element, index, array){//cada item del dia(subproceso)
						subprocess = {};
						subprocess.day_id = parseInt($(dayElement).attr('id-day'));
						subprocess.sequence = index+1;
						subprocess.id = parseInt(element.replace('item_',''));

						Subprocesses.update({id:subprocess.id},subprocess,function(response){
							countSubprocessesUpdated += 1;
							console.log(response);
							$('#progressUpdateSubprocesses span').css('width',countSubprocessesUpdated/countSubprocesses*100+"%");
							if(countSubprocesses===countSubprocessesUpdated){
								$('#ModalProgressUpdatingSubprocesses').foundation('reveal', 'close');//cerrar modal
								$('#progressUpdateSubprocesses span').css('width',"0%");//progreso de copia en 0
							}
						},function(error){
							alert(error.statusText);
						});
					});
				}
			});
		}else{
			console.log("cierre");
			$('#ModalProgressUpdatingSubprocesses').foundation('reveal', 'close');//cerrar modal
		}

	};
	$scope.endSubprocess = function(id_subprocess){
		console.log(id_subprocess);
		subprocess = {
			state:"terminado"
		};
		if (confirm("Esta seguro de terminar el subproceso "+id_subprocess+" ?")) {
			Subprocesses.update({id:id_subprocess},subprocess,function(data){
				if (data.state == "terminado") {
					alert("Terminado correctamente!");
					console.log(data);
					$scope.getSubprocesses();	
				}else{
					alert("Ocurrio un problema, informale a sistemas");
				}
			},function(error){
				alert("Error: "+error);
			});
		};

	};
	$scope.getMachineSearch = function(order_number){
		order_number = order_number.searchFish;//get text entry of user
		procedure_id = parseInt($('#procedure_id').val());
		if (order_number.length == 5 && parseInt(order_number)) {
			$http({
				method:'GET',
				url:'/orders_by_number/'+order_number+'.json'
			}).then(function(response){
				if (response.statusText === "OK") {//validete reponse
					response.data.subprocesses.forEach(function(item){//each all procedures of order
						if(item.procedure_id == procedure_id){//if its current procedure
							$('.label-link-machine').each(function(index, value ){
								if($(value).text() != item.machine){
									$(value).css('display','none');
								}
							});
						}
					});
				}
			});
		}else{
			$('.label-link-machine').each(function(index, value ){
					$(value).css('display','inline-block');
			});
		}
		
	};
	$scope.getSubprocesses();
}]);
		
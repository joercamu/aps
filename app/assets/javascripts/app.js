var app = angular.module("apsApp", ["ngResource","ngRoute"])
app.factory("apiKhronos",function(){
	return "192.168.1.247";
});
app.controller('OrdersController',function($scope,$resource,$routeParams){
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
	
	$scope.orders = Orders.query();

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
	//funcion que envia la señal para que se creen las rutas
	$scope.submitSubprocesses = function(){
		//Subprocesses = $resource("/subprocesses/:id.json",{id:"@id"},{update: {method: 'PUT'} });
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
				console.log(response)
				$scope.state_subprocesses = true;
			});
		};
	};
	//get process and machines, callback geOrder
	if (order_id){
		$scope.getProcedures($scope.getOrder);
	}
	
});
app.controller("leftoversController", function($scope,$resource,apiKhronos){
	$scope.leftover = {};
	infoLeftovers = $resource('http://'+apiKhronos+'/api_khronos/index.php/orders/get_orders_sheet/:id',{id:"@id"});
	$scope.get = function(){
		console.log("Consultando...");
		$scope.leftover = infoLeftovers.get({id:$scope.leftover.order_origin},function(){
			if (typeof $scope.leftover.order_origin != "undefined"){
				$('#leftover_order_origin').attr('readonly',true);
				$('#leftover_quantity').focus();
			}else{
				alert("Parece que hay un error, llama al admin! :)");
			}
				
		});
	};
			
});
		
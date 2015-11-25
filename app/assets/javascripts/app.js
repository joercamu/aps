var app = angular.module("apsApp", ["ngResource","ngRoute"])
app.factory("apiKhronos",function(){
	return "192.168.1.247";
});
app.controller('OrdersController',function($scope,$resource,$routeParams){
	
	$scope.programmed = false;//boolean for show or hide form "meters_programed"
	$scope.changes_saved = false;//boolean gor shoe or hide form "consult leftovers"
	//array with object for save order_leftovers
	$scope.order_leftovers = [];//registros a guardar
	$scope.new_order_leftover = {};//new registro
	$scope.new_order_leftover_index = 1;

	// orders, pedidos
	Orders = $resource("/orders/:id.json",{id:"@id"},{update: {method: 'PUT'} });
	// days, dias
	Days = $resource("/days.json");
	// Leftover, sobrantes
	Leftovers = $resource("/leftovers.json");


	//consult days available
	$scope.days = Days.query(function(response){
		console.log(response);
	});
	//consult order
	order_id = $('#IdOrder').val();
	$scope.order = Orders.get({id:order_id},function(response){
		//actualizo el dato enviado por el backend "sugerido segun formula @order.calculate_meters"
		$scope.order.scheduled_meters = $('#input_scheduled_meters').val();
		console.log(response);
	});
	//consult leftovers
	$scope.leftovers = Leftovers.query(function(response){
		console.log(response);
	});
	// function for add order_leftovers
	$scope.addHasLeftovers = function(leftover_id,sheet_code){
		$scope.new_order_leftover.leftover_id = leftover_id;
		$scope.new_order_leftover.order_id = order_id;
		$scope.new_order_leftover.sheet_code = sheet_code;
		$scope.new_order_leftover.index = $scope.new_order_leftover_index++;

		$scope.order_leftovers.push($scope.new_order_leftover);//add object at array
		$scope.new_order_leftover = {};//empty object
		console.log($scope.order_leftovers);
	};
	//
	$scope.removeHasLeftovers = function(element_at_remove){
		$scope.order_leftovers = $scope.order_leftovers.filter(function(element){
			console.log(element.index);
			console.log(element_at_remove);
			return element.index != element_at_remove;
		});
		console.log($scope.order_leftovers);
	};
	//guardar en la base de datos
	$scope.saveHasLeftovers = function(){
		HasLeftovers = $resource('/has_leftovers/:id.json',{id:"@id"});
		for (var i = 0; i < $scope.order_leftovers.length; i++) {
			HasLeftovers.save($scope.order_leftovers[i],function(response){
				console.log(response);
				$scope.changes_saved = true;
			});
		};
	};

	// funcion que actualizar los metros programados
	$scope.updateOrder = function(){
		Orders.update({id:order_id},$scope.order,function(response){
			console.log(response);
			$scope.programmed = true;
		});
	};
	//funcion que actualiza todos los subprocesos
	$scope.updateSubprocesses = function(){
		Subprocesses = $resource("/subprocesses/:id.json",{id:"@id"},{update: {method: 'PUT'} });
		for (var i = 0; i < $scope.order.subprocesses.length; i++) {
			Subprocesses.update({id:$scope.order.subprocesses[i].id},$scope.order.subprocesses[i],function(response){
				console.log(response)
			});
		};
	};
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
		
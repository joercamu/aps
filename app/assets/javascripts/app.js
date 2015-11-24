angular.module("apsApp", ["ngResource","ngRoute"])
.controller('OrdersController',function($scope,$resource,$routeParams){
	order_id = $('#IdOrder').val();

	Orders = $resource("/orders/:id.json",{id:"@id"},{update: {method: 'PUT'} });
	Days = $resource("/days.json");
	$scope.days = Days.query(function(response){
		console.log(response);
	});
	$scope.order = Orders.get({id:order_id},function(response){
		//actualizo el dato enviado por el backend "sugerido segun formula @order.calculate_meters"
		$scope.order.scheduled_meters = $('#input_scheduled_meters').val();
		console.log(response)
	});
	$scope.programmed = false;
	

	$scope.updateOrder = function(){

		Orders.update({id:order_id},$scope.order,function(response){
			console.log(response);
			$scope.programmed = true;
		});
	};
	$scope.updateSubprocesses = function(){
		Subprocesses = $resource("/subprocesses/:id.json",{id:"@id"},{update: {method: 'PUT'} });
		for (var i = 0; i < $scope.order.subprocesses.length; i++) {
			Subprocesses.update({id:$scope.order.subprocesses[i].id},$scope.order.subprocesses[i],function(response){
				console.log(response)
			});
		};
	};
	

});
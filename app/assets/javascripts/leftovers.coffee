# angular.module "apsApp"
# .controller "leftoversController", ($scope,$resource)->
# 	$scope.leftover = {}
# 	Leftovers = $resource('http://localhost/api_khronos/index.php/orders/get_orders_sheet/:id',{id:"@id"})
# 	$scope.get = ->
# 		console.log("Consultando...")
# 		$scope.leftover = Leftovers.get({id:$scope.leftover.order_origin},->
# 			if typeof $scope.leftover.order_origin != "undefined"
# 				$('#leftover_order_origin').attr('readonly',true)
# 				$('#leftover_quantity').focus()
# 			else
# 				alert "Parece que hay un error, llama al admin! :)"
# 			)
		
# 		# $scope.leftover.sheet_id = 93422
# 		# $scope.leftover.sheet_version = 3
# 		# $scope.leftover.sheet_composite = "PET"
# 		# $scope.leftover.um = "UND"
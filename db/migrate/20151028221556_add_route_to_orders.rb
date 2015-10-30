class AddRouteToOrders < ActiveRecord::Migration
  def change
  	add_reference :orders, :route, index:true, foreign_key: true
  end
end

class ChangeRouteToOrders < ActiveRecord::Migration
  def up
  	remove_reference :orders, :route, index: true, foreign_key: true
  end
  def down
  	add_column :orders, :route_id, :integer
  end
end

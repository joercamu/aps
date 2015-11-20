class ChangeStateToOrders < ActiveRecord::Migration
  def change
  	change_column :orders, :state, :string, default: "activo"
  end
end

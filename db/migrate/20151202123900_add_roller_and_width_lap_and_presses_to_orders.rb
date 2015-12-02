class AddRollerAndWidthLapAndPressesToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :sheet_roller, :string
    add_column :orders, :sheet_width_lap, :float
    add_column :orders, :presses, :string
  end
end

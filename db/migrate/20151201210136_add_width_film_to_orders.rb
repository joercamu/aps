class AddWidthFilmToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :sheet_width_planned, :float
  end
end

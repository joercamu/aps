class ChangeColumnOutsourcedIdToOrders < ActiveRecord::Migration
  def change
  	change_column :orders, :outsourced_id, :integer, :limit => 5
  end
end

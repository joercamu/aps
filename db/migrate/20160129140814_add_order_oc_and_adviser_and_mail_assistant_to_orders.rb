class AddOrderOcAndAdviserAndMailAssistantToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :order_oc, :string
    add_column :orders, :order_adviser, :string
    add_column :orders, :order_assistant_mail, :string
  end
end

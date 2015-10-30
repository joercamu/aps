class ChangeLimitToOrdes < ActiveRecord::Migration
  def up
  	change_column :orders, :outsourced_id, :integer, limit:11
  	change_column :orders, :order_number, :integer, limit:11
  	change_column :orders, :sheet_client, :integer, limit:11
  	change_column :orders, :sheet_id, :integer, limit:11
  end
    def down
  	change_column :orders, :outsourced_id, :integer, limit:4
  	change_column :orders, :order_number, :integer, limit:4
  	change_column :orders, :sheet_client, :integer, limit:4
  	change_column :orders, :sheet_id, :integer, limit:4
  end
end

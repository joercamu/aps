class RemoveStartTimeToDays < ActiveRecord::Migration
  def change
  	remove_column :days, :start_time
  end
end

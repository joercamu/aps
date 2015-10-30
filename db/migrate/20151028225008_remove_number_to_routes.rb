class RemoveNumberToRoutes < ActiveRecord::Migration
  def change
  	remove_column :routes, :number
  end
end

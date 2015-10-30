class ChangeFieldWasteToRoutes < ActiveRecord::Migration
  def change
  	change_column :routes, :waste, :float
  end
end

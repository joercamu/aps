class AddViewedToModifications < ActiveRecord::Migration
  def change
    add_column :modifications, :viewed, :boolean, default: false
  end
end

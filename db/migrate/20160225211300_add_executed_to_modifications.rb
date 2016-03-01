class AddExecutedToModifications < ActiveRecord::Migration
  def change
    add_column :modifications, :executed, :boolean
  end
end

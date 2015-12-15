class RenameColumnTypeToModifications < ActiveRecord::Migration
  def change
  	rename_column :modifications, :type, :modification_type
  end
end

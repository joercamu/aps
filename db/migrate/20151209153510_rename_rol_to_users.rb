class RenameRolToUsers < ActiveRecord::Migration
  def change
  	rename_column :users,:rol,:role
  end
end

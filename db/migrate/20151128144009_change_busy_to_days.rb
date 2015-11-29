class ChangeBusyToDays < ActiveRecord::Migration
  def change
  	change_column :days, :busy, :integer, default: 0
  end
end

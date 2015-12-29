class ChangeSetupTimetoSubprocesses < ActiveRecord::Migration
  def change
  	change_column :subprocesses, :setup_time, :integer, default: 15
  end
end

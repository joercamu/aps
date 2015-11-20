class AddSetupTimeToSubprocesses < ActiveRecord::Migration
  def change
    add_column :subprocesses, :setup_time, :integer, default:0
  end
end

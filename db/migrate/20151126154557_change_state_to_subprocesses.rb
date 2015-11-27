class ChangeStateToSubprocesses < ActiveRecord::Migration
  def change
  	change_column :subprocesses, :state, :string, default: 'activo'
  end
end

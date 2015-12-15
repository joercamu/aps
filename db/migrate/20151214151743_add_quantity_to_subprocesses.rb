class AddQuantityToSubprocesses < ActiveRecord::Migration
  def change
    add_column :subprocesses, :quantity_finished, :float, default:0
  end
end

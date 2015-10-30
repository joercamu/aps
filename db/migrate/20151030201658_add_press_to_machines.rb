class AddPressToMachines < ActiveRecord::Migration
  def change
    add_column :machines, :press, :string
  end
end

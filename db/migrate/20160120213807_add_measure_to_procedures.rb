class AddMeasureToProcedures < ActiveRecord::Migration
  def change
    add_column :procedures, :measure, :string
  end
end

class CreateProcedures < ActiveRecord::Migration
  def change
    create_table :procedures do |t|
      t.string :name
      t.boolean :press

      t.timestamps null: false
    end
  end
end

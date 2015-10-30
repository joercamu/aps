class CreateHasProcedures < ActiveRecord::Migration
  def change
    create_table :has_procedures do |t|
      t.references :machine, index: true, foreign_key: true
      t.references :procedure, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

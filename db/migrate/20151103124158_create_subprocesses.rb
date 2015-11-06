class CreateSubprocesses < ActiveRecord::Migration
  def up
    create_table :subprocesses do |t|
      t.references :order, index: true, foreign_key: true
      t.references :procedure, index: true, foreign_key: true
      t.references :standard, index: true, foreign_key: true
      t.integer :minutes
      t.datetime :start_date
      t.datetime :end_date
      t.integer :meter
      t.integer :sequence
      t.string :state

      t.timestamps null: false
    end
    def down
      drop_table :subprocesses
    end
  end
end

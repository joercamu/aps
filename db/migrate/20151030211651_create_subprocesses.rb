class CreateSubprocesses < ActiveRecord::Migration
  def change
    create_table :subprocesses do |t|
      t.references :order
      t.references :procedure
      t.references :standard
      t.integer :minutes
      t.datetime :start_date
      t.datetime :end_date
      t.integer :meters
      t.integer :sequence
      t.string :state

      t.timestamps null: false
    end
  end
end

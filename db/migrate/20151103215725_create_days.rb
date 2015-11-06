class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.references :machine, index: true, foreign_key: true
      t.date :day
      t.integer :shifts
      t.integer :hours
      t.integer :busy
      t.integer :available

      t.timestamps null: false
    end
  end
end

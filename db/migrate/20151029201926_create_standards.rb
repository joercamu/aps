class CreateStandards < ActiveRecord::Migration
  def change
    create_table :standards do |t|
      t.integer :index
      t.references :machine, index: true, foreign_key: true
      t.string :um
      t.integer :per_hour
      t.float :waste

      t.timestamps null: false
    end
  end
end

class CreateHasLeftovers < ActiveRecord::Migration
  def change
    create_table :has_leftovers do |t|
      t.references :order, index: true, foreign_key: true
      t.references :leftover, index: true, foreign_key: true
      t.float :quantity

      t.timestamps null: false
    end
  end
end

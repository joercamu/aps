class CreateLeftovers < ActiveRecord::Migration
  def change
    create_table :leftovers do |t|
      t.float :quantity
      t.float :quantity_available
      t.string :um
      t.float :weight
      t.string :location
      t.integer :order_origin
      t.integer :sheet_id
      t.integer :sheet_version
      t.date :entry_date
      t.string :disposition
      t.string :sheet_composite
      t.string :place_origin
      t.string :state

      t.timestamps null: false
    end
  end
end

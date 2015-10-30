class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :state
      t.float :weight
      t.integer :repeat
      t.references :route, index: true, foreign_key: true
      t.integer :scheduled_meters
      t.date :date_offer
      t.integer :outsourced_id, limit: 11
      t.string :outsourced_name
      t.integer :outsourced_tolerance_down
      t.integer :outsourced_tolerance_up
      t.date :order_date_request
      t.integer :order_number, limit: 11
      t.float :order_quantity
      t.string :order_type
      t.string :order_um
      t.float :order_unit_value
      t.float :sheet_caliber
      t.integer :sheet_client, limit: 11
      t.string :sheet_composite
      t.string :sheet_cut_type
      t.string :sheet_film
      t.float :sheet_guillotine
      t.float :sheet_height
      t.float :sheet_height_planned
      t.integer :sheet_id, limit:11
      t.float :sheet_meters_roll
      t.integer :sheet_number
      t.boolean :sheet_print
      t.string :sheet_product_type
      t.text :sheet_route
      t.integer :sheet_spaces
      t.integer :sheet_version
      t.float :sheet_width

      t.timestamps null: false
    end
  end
end

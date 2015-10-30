class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes, :id => false do |t|
      t.column :id, 'int(11) PRIMARY KEY'
      t.integer :number
      t.decimal :waste

      t.timestamps null: false
    end
  end
end

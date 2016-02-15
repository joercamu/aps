class AddFieldOutsourcedToLeftovers < ActiveRecord::Migration
  def change
    add_column :leftovers, :outsourced_id, :integer, :limit => 5
    add_column :leftovers, :outsourced_name, :string
  end
end

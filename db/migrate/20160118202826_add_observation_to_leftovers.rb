class AddObservationToLeftovers < ActiveRecord::Migration
  def change
    add_column :leftovers, :observation, :text
  end
end

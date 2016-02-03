class AddDepartureDateToLeftovers < ActiveRecord::Migration
  def change
    add_column :leftovers, :departure_date, :date
  end
end

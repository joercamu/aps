class AddInitTimeToDays < ActiveRecord::Migration
  def change
    add_column :days, :init_time, :datetime
  end
end

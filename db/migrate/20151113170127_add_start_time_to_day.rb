class AddStartTimeToDay < ActiveRecord::Migration
  def change
    add_column :days, :start_time, :time
  end
end

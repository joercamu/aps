class AddMinutesToDay < ActiveRecord::Migration
  def change
    add_column :days, :minutes, :integer
  end
end

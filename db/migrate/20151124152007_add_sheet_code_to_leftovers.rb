class AddSheetCodeToLeftovers < ActiveRecord::Migration
  def change
    add_column :leftovers, :sheet_code, :string
  end
end

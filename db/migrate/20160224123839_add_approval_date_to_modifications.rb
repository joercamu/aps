class AddApprovalDateToModifications < ActiveRecord::Migration
  def change
    add_column :modifications, :approval_date, :datetime
  end
end

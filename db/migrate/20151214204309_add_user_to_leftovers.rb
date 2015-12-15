class AddUserToLeftovers < ActiveRecord::Migration
  def change
    add_reference :leftovers, :user, index: true, foreign_key: true
  end
end

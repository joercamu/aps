class HasLeftover < ActiveRecord::Base
  belongs_to :order
  belongs_to :leftover
  after_save :update_leftover

  # subtract quantity of leftover available
  def update_leftover
  	new_leftover = self
  	leftover = Leftover.find(new_leftover.leftover_id)
  	leftover.update(quantity_available:leftover.quantity_available - new_leftover.quantity)
  end
end

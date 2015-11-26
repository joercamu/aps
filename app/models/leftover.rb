class Leftover < ActiveRecord::Base
	has_many :has_leftovers
	has_many :orders, through: :has_leftovers
	validates :order_origin,:sheet_id,:quantity,:state,:location, presence: true
	before_create :set_quantity_available

	scope :availables, -> {where("quantity_available > ?", 0)}
	
	def set_quantity_available
		self.quantity_available = self.quantity
	end
end

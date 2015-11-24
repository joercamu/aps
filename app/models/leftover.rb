class Leftover < ActiveRecord::Base
	has_many :has_leftovers
	has_many :orders, through: :has_leftovers
end

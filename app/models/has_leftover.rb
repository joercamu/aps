class HasLeftover < ActiveRecord::Base
  belongs_to :order
  belongs_to :leftover
end

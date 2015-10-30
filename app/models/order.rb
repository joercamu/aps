class Order < ActiveRecord::Base
  #belongs_to :route, :foreign_key => 'number'
  belongs_to :route
end

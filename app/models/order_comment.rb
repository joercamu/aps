class OrderComment < ActiveRecord::Base
  belongs_to :order
  belongs_to :user
  validates :order, presence:true
  validates :body, presence:true
end

class Subprocess < ActiveRecord::Base
  belongs_to :order
  belongs_to :procedure
  belongs_to :standard
  belongs_to :subprocess
  belongs_to :day
end

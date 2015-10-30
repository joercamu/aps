class HasProcedure < ActiveRecord::Base
  belongs_to :machine
  belongs_to :procedure
end

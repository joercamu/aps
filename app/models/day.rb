class Day < ActiveRecord::Base
  belongs_to :machine
  has_many :subprocesses

  def minutes
  	self.shifts.to_i * (self.hours.to_i * 60)
  end
end

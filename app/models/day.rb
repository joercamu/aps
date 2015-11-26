class Day < ActiveRecord::Base
  belongs_to :machine
  has_many :subprocesses
  validates :day, uniqueness: true, if: :exists_day?
  before_create :set_available

  scope :availables, -> {where('day > ?', DateTime.now.to_date).where('available > ?',0)}

  def minutes
  	self.shifts.to_i * (self.hours.to_i * 60)
  end
  def exists_day?
  	if Day.where(day:self.day).where(machine_id:self.machine_id).count > 0
  		true
  	else
  		false
  	end
  end
  def set_available
    self.available = self.minutes
  end
end

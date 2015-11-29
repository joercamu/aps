class Day < ActiveRecord::Base
  belongs_to :machine
  has_many :subprocesses

  # validates :day, uniqueness: true, if: :exists_day?
  # validates :day, :shifts, :hours, :start_time, presence: true
  before_create :set_available

  scope :availables, -> {where('day > ?', DateTime.now-1).where('available > ?',0).order(:day)}

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
  # update Day, busy = increase each subprocess.minutes
  def update_busy
    minutes = 0
    self.subprocesses do |subprocess|
      minutes = minutes + subprocess.minutes
    end
    self.busy = minutes
    self.save
  end

end

class Subprocess < ActiveRecord::Base
  belongs_to :order
  belongs_to :procedure
  belongs_to :standard
  belongs_to :subprocess
  belongs_to :day
  before_create :set_meter, :set_minutes
  after_save :set_start_date

  def set_meter
  	case self.procedure_id
  		when 4
  			self.meter = self.order.scheduled_meters  * self.order.sheet_spaces
  		when 5
  			self.meter = self.order.scheduled_meters  * self.order.sheet_spaces
  		when 7
  			self.meter = self.order.scheduled_meters  * self.order.sheet_spaces
  		when 9
  			self.meter = self.order.scheduled_meters  * self.order.sheet_spaces
  		else
  			self.meter = self.order.scheduled_meters
  	end
  end
  def set_minutes
  	if self.standard.um == "MTR"
  		self.minutes = (self.meter.to_f / self.standard.per_hour.to_f) * 60
  	end
  end
  def set_start_date
  	unless self.day_id.nil?
  		# self.update(start_date: DateTime.parse('#{self.day.day.to_s}'))
  	end
  end
end

class Subprocess < ActiveRecord::Base
  include AASM
  belongs_to :order
  belongs_to :procedure
  belongs_to :standard
  belongs_to :subprocess
  belongs_to :day
  
  before_create :set_meter, :set_minutes, :set_day, :set_start_date
  before_update :set_start_date
  after_create :validate_day
  after_update :validate_day
  

  def set_meter
    if self.order.sheet_print
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
    else
         self.meter = self.order.scheduled_meters 
    end

  end
  def set_day
    #assign day available to subprocess
    if self.standard.machine.days.availables.where('available >= ?',self.minutes).any?
      temp_day = self.standard.machine.days.availables.where('available >= ?',self.minutes).take!.id
      self.day_id = temp_day
      self.sequence = Day.find(temp_day).subprocesses.count+1
    end
  end
  def set_minutes
  	if self.standard.um == "MTR"
  		self.minutes = (self.meter.to_f / self.standard.per_hour.to_f) * 60
  	end
  end
  def validate_day
    unless self.day_id.nil?
      self.approve! if self.may_approve?
    end
  end
  def set_start_date
    # generate start day
    # 1 Day subprocess:[{id:2,secuence:1},{id:2,secuence:2}]
    unless self.day_id.nil?
      f = self.day.day.strftime("%F").to_s #DATE 
      t = self.day.start_time.strftime("%T%:z").to_s #TIME INITIAL
      dateTimeInitial = DateTime.parse("#{f} #{t}")
      count_minutes = 0

      Day.find(self.day_id).subprocesses.order(:sequence).each do |subprocess|
        if self.id == subprocess.id
          puts "cali #{self.id} igual #{subprocess.id} sumar#{count_minutes}"
          temp_date = dateTimeInitial+(count_minutes.to_f/1440)
          self.start_date = temp_date
          self.end_date = temp_date+(self.minutes.to_f/1440)
        else
          count_minutes = count_minutes + subprocess.minutes
        end
      end
    end
  end
  aasm column: "state" do
    state :activo, initial:true
    state :programado
    state :teminado

    event :approve do 
      transitions :from => :activo, :to => :programado
    end
    event :end do 
      transitions :from => :programado, :to => :terminado
    end
  end
end

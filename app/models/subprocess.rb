class Subprocess < ActiveRecord::Base
  include AASM
  belongs_to :order
  belongs_to :procedure
  belongs_to :standard
  belongs_to :day
  
  before_create :set_meter, :set_minutes, :set_day

  before_save :set_start_date,:change_state_order

  after_create :validate_day
  after_update :validate_day
  
  scope :scheduled, -> {where(state:"programado")}
  
  def set_meter
    if self.order.sheet_print
      case self.procedure_id
        when 4
          self.meter = self.order.scheduled_meters  * self.order.sheet_spaces
        when 5
          self.meter = self.order.scheduled_meters  * self.order.sheet_spaces
        when 6
          self.meter = self.order.scheduled_meters  * self.order.sheet_spaces
        when 7
          self.meter = self.order.scheduled_meters  * self.order.sheet_spaces
        when 8
          self.meter = self.order.scheduled_meters  * self.order.sheet_spaces
        when 9
          self.meter = self.order.scheduled_meters  * self.order.sheet_spaces
        when 11
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
    if self.standard.machine.days.availables.where('available >= ?',self.minutes+self.setup_time).any?
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
    # generate start day if have day assign
    # 1 Day subprocess:[{id:2,secuence:1},{id:2,secuence:2}]
    unless self.day_id.nil?
      # update minutes to day (mejorar ya que cada actualizacion ejecutará este metodo)
      self.standard.machine.days.each do |day|
        day.update_busy
      end 
      # convert date
      f = self.day.day.strftime("%F").to_s #DATE 
      t = self.day.init_time.strftime("%T%:z").to_s #TIME INITIAL
      dateTimeInitial = DateTime.parse("#{f} #{t}")
      count_minutes = 0

      Day.find(self.day_id).subprocesses.order(:sequence).each do |subprocess|
        if self.id == subprocess.id
          puts "cali #{self.id} igual #{subprocess.id} sumar #{count_minutes}"
          temp_date = dateTimeInitial+(count_minutes.to_f/1440)
          self.start_date = temp_date
          self.end_date = temp_date+((self.minutes.to_f+self.setup_time.to_f)/1440)
        else
          count_minutes = count_minutes + (subprocess.minutes+subprocess.setup_time)
        end
      end
    end
  end
  # cuando se termina un subproceso, cambia el estado a en_proceso y si es el ultimo lo coloca en terminado
  def change_state_order
    if self.state == "terminado"
      if self.order.subprocesses.last.id == self.id
        self.order.end! if self.order.may_end?
      else
        self.order.start! if self.order.may_start?
      end
      
    end
  end
  aasm column: "state" do
    state :activo, initial:true
    state :programado
    state :terminado

    event :approve do 
      transitions :from => :activo, :to => :programado
    end
    event :end do 
      transitions :from => :programado, :to => :terminado
      before do
        self.order.start! if self.order.may_start?
      end
    end
  end
end

class Order < ActiveRecord::Base
  include AASM
  belongs_to :route
  has_many :subprocesses
  before_create :set_repeat
    # Campo que se tiene que editar aqui! 
    # t.string   "state",                     limit: 255
    # t.float    "weight",                    limit: 24
    # t.integer  "repeat",                    limit: 4
    # t.integer  "scheduled_meters",          limit: 4
    # t.date     "date_offer"
    # t.integer  "route_id", 

  def create_subprocesses data
  	count = 0
  	data.each do |key,value|
  		count = count + 1
  		Subprocess.create(sequence:count,order_id:self.id ,procedure_id:key, standard_id:value.id)
  	end
  end
  def set_repeat
    order = self.order_number
    self.repeat = Order.where(order_number:order).count + 1
  end
  def calculate_meters
    case self.order_um
      when "UND"
        
      when "ROL"
      when "KIL"
    end
    self.update(scheduled_meters:300)
  end
  aasm column: "state" do
    state :activo, initial: true
    state :aprobado
    state :rechazado
    state :programado
    state :reprogramado
    state :en_proceso
    state :suspendido
    state :terminado

    event :approve do
      transitions :from => :activo, :to => :aprobado
      transitions :from => :rechazado, :to => :aprobado
    end
    event :schedule do
      transitions :from => :aprobado, :to => :programado
    end
    event :start do
      transitions :from => :programado, :to => :en_proceso
      transitions :from => :suspendido, :to => :en_proceso
    end
    event :end do
      transitions :from => :en_proceso, :to => :terminado
    end
    event :refuse do
      transitions :from => :activo, :to => :rechazado
      transitions :from => :aprobado, :to => :rechazado
    end
    event :suspend do
      transitions :from => :programado, :to => :suspendido
      transitions :from => :en_proceso, :to => :suspendido
    end
    event :reschedule do
      transitions :from => :programado, :to => :reprogramado
      transitions :from => :suspendido, :to => :reprogramado
    end
  end

end

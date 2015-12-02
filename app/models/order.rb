class Order < ActiveRecord::Base
  include AASM
  belongs_to :route
  has_many :subprocesses
  has_many :has_leftovers
  has_many :leftovers, through: :has_leftovers
  has_many :order_comments

  before_create :set_repeat
  before_save :set_date_offer
  validates :order_number, uniqueness: true, if: :exists_order?
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
  		@subprocess = Subprocess.create(sequence_process:count,order_id:self.id ,procedure_id:key, standard_id:value.id)
  	end
  end
  def set_repeat
    order = self.order_number
    self.repeat = Order.where(order_number:order).count + 1
  end
  def calculate_meters quantity
    quantity = quantity.to_f
    case self.order_um
      when "UND"
        # self.outsourced_tolerance_up/100.to_f
        meter = ((quantity/1000)*self.sheet_height)*(1+(self.outsourced_tolerance_up.to_f/100)+self.route.waste)
        if self.sheet_spaces > 0
          meter / self.sheet_spaces
        else
          meter
        end
      when "ROL"
        meter = (quantity*sheet_meters_roll)*(1+(self.outsourced_tolerance_up.to_f/100)+self.route.waste)
        if self.sheet_spaces > 0
          meter / self.sheet_spaces
        else
          meter
        end
      when "KIL"
        ((quantity/(self.sheet_width_planned*((self.sheet_caliber.to_f/25.4)/1000)*0.072))*2)*(1+(self.outsourced_tolerance_up.to_f/100)+self.route.waste)
      when "MTR"
        quantity
    end
  end
  def exists_order?
    if Order.where(order_number:self.order_number).where(state:self.state).count > 0
      true
    else
      false
    end
  end
  def set_date_offer
    if self.subprocesses.any? && self.subprocesses.order(:sequence_process).last.end_date
        self.date_offer = self.subprocesses.order(:sequence_process).last.end_date+172800
    end
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

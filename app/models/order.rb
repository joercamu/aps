class Order < ActiveRecord::Base
  include AASM
  belongs_to :route
  belongs_to :user
  has_many :subprocesses
  has_many :has_leftovers
  has_many :leftovers, through: :has_leftovers
  has_many :order_comments
  has_many :modifications

  before_create :set_repeat
  # before_save :set_date_offer
  validates :order_number, uniqueness: true, if: :exists_order?, :on => :create
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
        if self.sheet_print == false && sheet_cut_type == "SELLADO"
          temp_height = self.sheet_height + 10
        elsif self.sheet_print && self.sheet_cut_type == "CORTADO" && self.sheet_guillotine > 0
          temp_height = self.sheet_height_planned
        elsif self.sheet_print && sheet_cut_type == "SELLADO"
          temp_height = self.sheet_height_planned
        else
          temp_height = sheet_height
        end
        
        # self.outsourced_tolerance_up/100.to_f
        meter = ((quantity/1000)*temp_height.to_f)*(1+(self.outsourced_tolerance_up.to_f/100)+self.route.waste)
        if self.sheet_spaces
          meter / self.sheet_spaces
        else
          meter
        end
      when "ROL"
        # si la cantidad es menor a 5 rollos se aumenta el 10%
        if quantity <= 5 && self.sheet_print
          additional_waste = 0.1
        else
          additional_waste = 0
        end
        meter = (quantity*sheet_meters_roll)*(1+(self.outsourced_tolerance_up.to_f/100)+self.route.waste+additional_waste)
        # si tiene cabidas, divide sobre ellas
        if self.sheet_spaces
          meter / self.sheet_spaces
        else
          meter
        end
      when "KIL"
        if self.sheet_print
          ((quantity/(self.sheet_width_planned*((self.sheet_caliber.to_f/25.4)/1000)*0.072))*2)*(1+(self.outsourced_tolerance_up.to_f/100)+self.route.waste)
        else
          ((quantity/(((self.sheet_width*2)+sheet_width_lap)*((self.sheet_caliber.to_f/25.4)/1000)*0.072))*2)*(1+(self.outsourced_tolerance_up.to_f/100)+self.route.waste)
        end
        
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
  def date_offer
    if self.subprocesses.any? && self.subprocesses.order(:sequence_process).last.day
        # 2d = 172800 sg
        myDate = self.subprocesses.order(:sequence_process).last.day.day+2
        myDate.strftime("%F")
    end
  end
  # def set_date_offer
  #   if self.subprocesses.any? && self.subprocesses.order(:sequence_process).last.end_date
  #       self.date_offer = self.subprocesses.order(:sequence_process).last.end_date+172800
  #   end
  # end
  def log_status_change
    # puts "changing from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})"
    OrderComment.create(user_id:1,order_id:self.id,body:"Cambio de estado, de #{aasm.from_state} a #{aasm.to_state}")
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

    after_all_transitions :log_status_change
    event :activate do
      transitions :from => :rechazado, :to => :activo
    end
    event :approve do
      transitions :from => :activo, :to => :aprobado
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
      transitions :from => :terminado, :to => :reprogramado
    end
    event :reapprove do
      transitions :from => :programado, :to => :aprobado
    end
  end

end

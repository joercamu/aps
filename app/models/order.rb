class Order < ActiveRecord::Base
  include AASM
  belongs_to :route
  has_many :subprocesses
  before_save :set_repeat
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

  aasm column: "state" do
    state :activo, initial: true
    state :aprobado
    state :rechazado
    state :en_programacion
    state :programado
    state :reprogramado
    state :en_proceso
    state :suspendido
    state :terminado

    event :approve do
      transitions :from => :activo, :to => :aprobado
    end

  end
end

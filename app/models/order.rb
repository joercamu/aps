class Order < ActiveRecord::Base
  belongs_to :route
  has_many :subprocesses
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
end

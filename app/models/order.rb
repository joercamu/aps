class Order < ActiveRecord::Base
  #belongs_to :route, :foreign_key => 'number'
  belongs_to :route
  has_many :subprocesses

  def create_subprocesses data
  	count = 0
  	data.each do |key,value|
  		count = count + 1
  		Subprocess.create(sequence:count,order_id:self.id ,procedure_id:key, standard_id:value.id)
  	end
  end
end

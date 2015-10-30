class UpdatePressToMachines < ActiveRecord::Migration
  def change
  	#no existe la p4
  	@press = [
		{name:'ALLIED GEAR',press:'Allied Gear'},	
		{name:'BRIKS',press:'BRIKS'},	
		{name:'EKA',press:'EKA'},	
		{name:'FLEXIPACK',press:'flexipack'},	
		{name:'IBI 2',press:'IBI 2'},	
		{name:'IBIRAMA 3',press:'ibi3'},	
		{name:'INDEMO',press:'Indemo'},	
		{name:'MK 1',press:'MK 1'},	
		{name:'MK2200',press:'MK2200'},	
		{name:'MARKANDY P5',press:'p5'},	
		{name:'SEAT',press:'seat'}
	]
	@press.each do |press|
		machine = Machine.find_by(name:press[:name])
		unless machine.nil?
			machine.press = press[:press]
			machine.save
		end
	end
  end
end

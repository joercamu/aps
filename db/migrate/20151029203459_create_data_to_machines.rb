class CreateDataToMachines < ActiveRecord::Migration
  def change
    @machines = [
    	{name:'ALLIED GEAR'},
		{name:'BRIKS'},
		{name:'CAV'},
		{name:'CAV 12'},
		{name:'CAV 6'},
		{name:'CAV 7'},
		{name:'EKA'},
		{name:'EXTRUSORA 15'},
		{name:'EXTRUSORA 2'},
		{name:'EXTRUSORA 7'},
		{name:'EXTRUSORA 9'},
		{name:'FLEXIPACK'},
		{name:'GUILLOTINA'},
		{name:'IBI 2'},
		{name:'IBIRAMA 3'},
		{name:'INDEMO'},
		{name:'MARKANDY P5'},
		{name:'MK 1'},
		{name:'MK2200'},
		{name:'PEGADORA 1'},
		{name:'PEGADORA 2'},
		{name:'PEGADORA 3'},
		{name:'PEGADORA 4'},
		{name:'PREFORMADORA 10'},
		{name:'PREFORMADORA 11 A'},
		{name:'PREFORMADORA 11B'},
		{name:'PREFORMADORA 9'},
		{name:'PRENSA 4'},
		{name:'REBOBINADORA 5'},
		{name:'REBOBINADORA 6'},
		{name:'REVISADORA'},
		{name:'SEAT'},
		{name:'SELLADORA 10'},
		{name:'SELLADORA 2'},
		{name:'SELLADORA 9'},
		{name:'SLITER 1'},
		{name:'SLITER 3'}
    ]
    @machines.each do |machine|
    	Machine.create(machine)
    end
  end
end

class CreateDataToHasProcedures < ActiveRecord::Migration
  def change
	@procedures_machines = [
      {procedure_id: 1, machine_name:'EXTRUSORA 2'},
      {procedure_id: 1, machine_name:'EXTRUSORA 7'},
      {procedure_id: 1, machine_name:'EXTRUSORA 9'},
      {procedure_id: 1, machine_name:'EXTRUSORA 15'},
      {procedure_id: 2, machine_name:'SLITER 1'},
      {procedure_id: 2, machine_name:'SLITER 3'},
      {procedure_id: 3, machine_name:'MARKANDY P5'},
      {procedure_id: 3, machine_name:'ALLIED GEAR'},
      {procedure_id: 3, machine_name:'PRENSA 4'},
      {procedure_id: 3, machine_name:'SEAT'},
      {procedure_id: 3, machine_name:'IBIRAMA 3'},
      {procedure_id: 4, machine_name:'PEGADORA 1'},
      {procedure_id: 4, machine_name:'PEGADORA 2'},
      {procedure_id: 4, machine_name:'PEGADORA 3'},
      {procedure_id: 4, machine_name:'PEGADORA 4'},
      {procedure_id: 5, machine_name:'CAV'},
      {procedure_id: 5, machine_name:'CAV 7'},
      {procedure_id: 5, machine_name:'CAV 12'},
      {procedure_id: 6, machine_name:'SELLADORA 2'},
      {procedure_id: 6, machine_name:'SELLADORA 9'},
      {procedure_id: 6, machine_name:'SELLADORA 10'},
      {procedure_id: 7, machine_name:'REBOBINADORA 5'},
      {procedure_id: 8, machine_name:'GUILLOTINA'},
      {procedure_id: 9, machine_name:'PREFORMADORA 9'},
      {procedure_id: 9, machine_name:'PREFORMADORA 10'},
      {procedure_id: 9, machine_name:'PREFORMADORA 11 A'},
      {procedure_id: 9, machine_name:'PREFORMADORA 11B'},
      {procedure_id: 10,  machine_name:'REVISADORA'},
      {procedure_id: 10,  machine_name:'SLITER 3'},
      {procedure_id: 11,  machine_name:'CAV 6'},
      {procedure_id: 3, machine_name:'INDEMO'},
      {procedure_id: 3, machine_name:'IBI 2'},
      {procedure_id: 3, machine_name:'MK 1'},
      {procedure_id: 7, machine_name:'REBOBINADORA 6'},
      {procedure_id: 3, machine_name:'FLEXIPACK'},
      {procedure_id: 3, machine_name:'EKA'},
      {procedure_id: 3, machine_name:'BRIKS'},
      {procedure_id: 3, machine_name:'MK2200'}
    ]
    @procedures_machines.each do |procedure_machine|
    	HasProcedure.create(machine_id:Machine.find_by(name:procedure_machine[:machine_name]).id,procedure_id:procedure_machine[:procedure_id])
	end
  end
end

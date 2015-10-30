class CreateDataToProcedures < ActiveRecord::Migration
  def change
  	@processes = [
		{name:'EXTRUSIÓN', press:false},
		{name:'REFILE DE MATERIAL', press:false},
		{name:'PRENSA', press:true},
		{name:'PEGADO', press:false},
		{name:'CORTE', press:false},
		{name:'CORTE Y SELLE', press:false},
		{name:'REBOBINE', press:false},
		{name:'GUILLOTINADO', press:false},
		{name:'PREFORMADO', press:false},
		{name:'	REVISIÓN', press:false},
		{name:'	PRECORTE', press:false}
	]
	@processes.each do |process|
  		Procedure.create(process)
    end
  end
end

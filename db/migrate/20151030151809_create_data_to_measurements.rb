class CreateDataToMeasurements < ActiveRecord::Migration
  def change
    @measurements = [
    	{name:'UNIDADES',value:'UND'},
    	{name:'ROLLOS',value:'ROL'},
    	{name:'KILOS',value:'KIL'},
    	{name:'METROS',value:'MTR'}
    ]
    @measurements.each do |measurement|
    	Measurement.create(measurement)
    end
  end
end

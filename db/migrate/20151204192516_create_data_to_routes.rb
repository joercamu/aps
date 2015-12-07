class CreateDataToRoutes < ActiveRecord::Migration
  def change
        @routes = [
    	{id:43,waste:0.03},
    	{id:46,waste:0.1}
    	]
	    @routes.each do |route|
	    	Route.create(route)
	    end
  end
end
class HasLeftoversController < ApplicationController
	before_action :set_has_leftover, only:[:show]
	skip_before_action :verify_authenticity_token

	def index
		@has_leftovers = HasLeftover.all
	end
	def new
		@has_leftovers = HasLeftover.new
	end
	def show

	end
	def create
		@has_leftover = HasLeftover.new(has_leftover_params)
		respond_to do |format|
			if @has_leftover.save
				format.json {render :show, status: :created, location: @has_leftover}
			else
				format.json { render json: @has_leftover.errors, status: :unprocessable_entity}
			end
		end
	end

	def set_has_leftover
		@has_leftover = HasLeftover.find(params[:id])
	end
	def has_leftover_params
		params.require(:has_leftover).permit(:order_id,:leftover_id,:quantity)
	end
end

class OrderCommentsController < ApplicationController
	before_action :set_comment, only: [:show,:edit,:update,:destroy]
	before_action :set_order, only: [:create]
	def new
		# @comment = OrderComment.new
	end
	def create
		# @comment = OrderComment.new(comment_params)
		@comment = current_user.order_comments.new(comment_params)
		@comment.order = @order
		respond_to do |format|
			if @comment.save
				format.html {redirect_to @comment.order}
				format.json { render :show, status: :created, location: @order }
			else
				format.html {}
			end
		end
	end
	def set_comment
		@comment = OrderComment.find(params[:id])
	end
	def set_order
		@order = Order.find(params[:order_id])
	end
	def comment_params
		# params.require(:has_leftover).permit(:order_id,:leftover_id,:quantity)
		params.require(:order_comment).permit(:order_id, :user_id, :body)
	end

end

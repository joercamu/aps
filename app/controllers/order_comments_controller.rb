class OrderCommentsController < ApplicationController
	def new
		# @comment = OrderComment.new
	end
	def create
		@comment = OrderComment.new(comment_params)
		respond_to do |format|
			if @comment.save
				format.html {}
			else
				format.html {}
			end
		end
	end
	def set_comment
		@comment = OrderComment.find(params[:id])
	end
	def comment_params
		# params.require(:has_leftover).permit(:order_id,:leftover_id,:quantity)
		params.require(:order_comment).permit(:order_id, :user_id, :body)
	end

end

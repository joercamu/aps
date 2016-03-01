class ModificationCommentsController < ApplicationController
  before_action :set_modification_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_modification, only:[:create]

  # GET /modification_comments
  # GET /modification_comments.json
  def index
    @modification_comments = ModificationComment.all
  end

  # GET /modification_comments/1
  # GET /modification_comments/1.json
  def show
  end

  # GET /modification_comments/new
  def new
    @modification_comment = ModificationComment.new
  end

  # GET /modification_comments/1/edit
  def edit
  end

  # POST /modification_comments
  # POST /modification_comments.json
  def create
    @modification_comment = current_user.modification_comments.new(modification_comment_params)
    @modification_comment.modification = @modification
    respond_to do |format|
      if @modification_comment.save
        format.html { redirect_to @modification_comment.modification, notice: 'Comentario creado exitosamente.' }
        format.json { render :show, status: :created, location: @modification_comment }
      else
        format.html { render :new }
        format.json { render json: @modification_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /modification_comments/1
  # PATCH/PUT /modification_comments/1.json
  def update
    respond_to do |format|
      if @modification_comment.update(modification_comment_params)
        format.html { redirect_to @modification_comment, notice: 'Modification comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @modification_comment }
      else
        format.html { render :edit }
        format.json { render json: @modification_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /modification_comments/1
  # DELETE /modification_comments/1.json
  def destroy
    @modification_comment.destroy
    respond_to do |format|
      format.html { redirect_to modification_comments_url, notice: 'Modification comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_modification_comment
      @modification_comment = ModificationComment.find(params[:id])
    end
    def set_modification
      @modification = Modification.find(params[:modification_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def modification_comment_params
      params.require(:modification_comment).permit(:modification_id, :user_id, :body)
    end
end

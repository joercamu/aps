class ModificationsController < ApplicationController
  before_action :set_modification, only: [:show, :edit, :update, :destroy,:approve,:refuse]
  before_action :set_order, only: [:create,:show]
  load_and_authorize_resource
  
  # GET /modifications
  # GET /modifications.json
  def index
    if current_user.role == "vendedor" && user_signed_in? 
        @modifications = current_user.modifications.all
    else
      @modifications = Modification.all
    end
  end

  # GET /modifications/1
  # GET /modifications/1.json
  def show
  end

  # GET /modifications/new
  def new
    @modification = Modification.new
  end

  # GET /modifications/1/edit
  def edit
  end

  # POST /modifications
  # POST /modifications.json
  def create
    @modification = current_user.modifications.new(modification_params)
    @modification.order = @order

    respond_to do |format|
      if @modification.save
        format.html { redirect_to @modification.order, notice: 'La Modificacion ha sido creada.' }
        format.json { render :show, status: :created, location: @modification }
      else
        format.html { render :new }
        format.json { render json: @modification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /modifications/1
  # PATCH/PUT /modifications/1.json
  def update
    respond_to do |format|
      if @modification.update(modification_params)
        format.html { redirect_to @modification, notice: 'Modification was successfully updated.' }
        format.json { render :show, status: :ok, location: @modification }
      else
        format.html { render :edit }
        format.json { render json: @modification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /modifications/1
  # DELETE /modifications/1.json
  def destroy
    @modification.destroy
    respond_to do |format|
      format.html { redirect_to modifications_url, notice: 'Modification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def m_approve
    @modification.approve! if @modification.may_approve?
    redirect_to modifications_url
  end
  def m_refuse
    @modification.refuse! if @modification.may_refuse?
    redirect_to modifications_url
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:order_id])
    end
    def set_modification
      @modification = Modification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def modification_params
      params.require(:modification).permit(:order_id, :priority, :modification_type, :body, :user_id, :state)
    end
end

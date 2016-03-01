class ModificationsController < ApplicationController
  before_action :set_modification, only: [:show, :edit, :update, :destroy,:approve,:refuse,:mark_as_unread,:mark_as_executed]
  before_action :set_order, only: [:create]
  load_and_authorize_resource
  helper ModificationsHelper
  
  # GET /modifications
  # GET /modifications.json
  def index
    if current_user.role == "vendedor" && user_signed_in? 
      @modifications = current_user.modifications.all.by_date
    else
      @modifications = Modification.all.by_date
    end
  end

  # GET /modifications/1
  # GET /modifications/1.json
  def show
    @modification_comment = ModificationComment.new
    @modification_attachment = ModificationAttachment.new
    @modification_attachments = @modification.modification_attachments

    if @modification.viewed == false && current_user.role == "programador"
      @modification.update(viewed:true)
    end
  end

  # GET /modifications/new
  def new
    @modification = Modification.new
  end

  # GET /modifications/1/edit
  def edit
    redirect_to @modification.order, notice: 'Esta modificacion no te pertenece, solicitale al creador que la modifique.' if current_user != @modification.user
    redirect_to @modification.order, notice: 'No se puede editar, debido a que ha cambiado de estado.' if @modification.state != "activo" 
  end

  # POST /modifications
  # POST /modifications.json
  def create
    @modification = current_user.modifications.new(modification_params)
    @modification.order = @order

    respond_to do |format|
      if @modification.save
        # send email
        ModificationMailer.create_modification_confirmation(current_user,@modification).deliver
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
    if @modification.state != "activo" 
      redirect_to @modification, notice: 'No se puede eliminar, debido a que ha cambiado de estado.' 
    elsif @modification.user != current_user
      redirect_to @modification, notice: 'Solo puede eliminar la modificacion quien la creo.' 
    else
      @modification.destroy
      respond_to do |format|
        format.html { redirect_to modifications_url, notice: 'Modification was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end
  def m_approve
    if @modification.may_approve?
      @modification.approve! 
      @modification.update(approval_date:DateTime.now)
      ModificationMailer.change_state_modification(@modification).deliver
      redirect_to modifications_url, notice: 'La modificacion fue aprobada correctamente.'
    end
  end
  def m_refuse
    if @modification.may_refuse?
      @modification.refuse! 
      @modification.update(approval_date:DateTime.now)
      ModificationMailer.change_state_modification(@modification).deliver
      redirect_to modifications_url, notice: 'La modificacion fue rechazada correctamente.'
    end
  end 
  def mark_as_unread
    if @modification.update(viewed:false)
      redirect_to modifications_url, notice: 'La modificacion se ha marcado como no leida correctamente.'
    end
  end
  def mark_as_executed
    if @modification.update(executed:!@modification.executed)
      ModificationMailer.mark_executed_modification(@modification).deliver
      redirect_to @modification, notice: 'Se ha actualizado correctamente la modification.'
    end
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
      params.require(:modification).permit(:order_id, :priority, :modification_type, :body, :user_id, :state,:file)
    end
end

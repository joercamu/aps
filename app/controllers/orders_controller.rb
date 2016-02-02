class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :schedule,:new_subprocess,:calculate_meters,:change_state,:approve_order,:remove_subprocesses,:m_reactivate]
  before_action :set_subprocesses, only:[:show,:schedule]
  after_action :show, only:[:by_number]
  skip_before_action :verify_authenticity_token
  load_and_authorize_resource

  # GET /orders
  # GET /orders.json
  def index
  end
  # GET /orders_search
  def search
  end
  # POST /orders_search
  def search_filter
    case params[:filter_key]
    when 'order_number'
      @orders = Order.where(order_number:params[:filter_value])  
    when 'sheet_number'
      sheet_code = params[:filter_value].split("-")
      # "#{order.sheet_client}-#{order.sheet_number}"
      @orders = Order.where(sheet_client:sheet_code.first.to_i)
      @orders = @orders.where(sheet_number:sheet_code.last.to_i)
    when 'outsourced_name'
      @orders = Order.where('outsourced_name like ?', "%"+params[:filter_value]+"%") 
    when 'order_oc'
      @orders = Order.where(order_oc:params[:filter_value])  
    else
      @orders = Order.all

    end
    # filter state
    if params[:state] != ''
      @orders = @orders.where(state:params[:state])
    end
    respond_to do |format|
      # raise
      format.html{render :index}
      format.xls{render :index}
    end 
    
    
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @subprocesses = @order.subprocesses
    @has_leftovers = @order.has_leftovers
    @comment = OrderComment.new
    @modification = Modification.new
    @modifications = @order.modifications
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = current_user.orders.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  #GET /get_orders
  def get
  end
  #GET /orders/:id/schedule
  def schedule
    # @meters = @order.calculate_meters
    @modifications = @order.modifications
  end

  def calculate_meters
    @meters = @order.calculate_meters(params[:quantity])
  end
  #GET /new_subprocesses/:id
  def new_subprocess
    @route_all = @order.sheet_route
    @procedures = {}
    #separar la cadena por proceso y maquina
    @route_all.split(",").each_with_index do |route,index|
      detail = route.split("-")
      machine = Machine.find_by(name:detail.last)
      #validar que cada maquina tengan standard creado
      standard = Standard.find_by(machine_id:machine)
      if @order.subprocesses.any?
        @order.errors.add(:errors,"Ya existen procesos creados.")
      end
      if standard.nil?
        @order.errors.add(:errors,"No hay estandar para la maquina #{detail.last}")
      else
        @procedures[detail.first] = standard
      end
    end
    respond_to do |format|
      if @order.errors.any?
        format.json { render json: @order.errors}
      else
        @order.create_subprocesses(@procedures)
        format.json { render :show, status: :created, location: @order }
      end
    end
  end
  #GET 
  def change_state
    @state = params[:state]
    case @state
      when "approve"
        @order.approve! if @order.may_approve?
      when "refuse"
        @order.refuse! if @order.may_refuse?
      when "suspend"
        @order.suspend! if @order.may_suspend?
      when "end"
        @order.end! if @order.may_end?  
      when "activate"
        @order.activate! if @order.may_activate?  
    end
    redirect_to @order 
  end
  def approve_order
    count = 0
    count_subprocess = @order.subprocesses.count
    if count_subprocess == 0
      @order.errors.add(:errors,"No hay subprocesos")
    else
      @order.subprocesses.each do |subprocess|
        count += 1 if subprocess.state=="programado"
      end
    end

    respond_to do |format|
      if count == count_subprocess && @order.subprocesses.any?
        if @order.may_schedule?
          @order.schedule!
          format.json {render json:{state:"ok"}}
        end
      else
        @order.errors.add(:errors,"Faltan #{count_subprocess-count} procesos por programar")
        format.json {render json: @order.errors}
      end
    end
  end
  def remove_subprocesses
    @order.subprocesses.destroy_all
    @order.reapprove! if @order.may_reapprove?
    redirect_to @order, notice:"Procesos eliminados correctamente"
  end
  def m_reactivate
    @order.activate! if @order.may_activate?
    redirect_to @order
  end
  def by_number
    @order = Order.find_by(order_number:params[:order_number])
    render 'show'
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end
    def set_subprocesses
      @subprocesses = @order.subprocesses
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:scheduled_meters,:route_id, :outsourced_id, :outsourced_name, :outsourced_tolerance_down, :outsourced_tolerance_up, :order_date_request, :order_number, :order_quantity, :order_type, :order_um, :order_unit_value, :sheet_caliber, :sheet_client, :sheet_composite, :sheet_cut_type, :sheet_film, :sheet_guillotine, :sheet_height, :sheet_height_planned, :sheet_id, :sheet_meters_roll, :sheet_number, :sheet_print, :sheet_product_type, :sheet_route, :sheet_spaces, :sheet_version, :sheet_width,:sheet_width_planned,:sheet_roller,:sheet_width_lap,:presses,:order_oc,:order_adviser,:order_assistant_mail)
    end
end

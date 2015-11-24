class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :schedule,:new_subprocess]
  before_action :set_subprocesses, only:[:show,:schedule]
  skip_before_action :verify_authenticity_token

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @subprocesses = @order.subprocesses
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
    @order = Order.new(order_params)

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
    @meters = @order.calculate_meters
  end
  # CREATE subprocess POST
  def new_subprocess
    @route_all = @order.sheet_route
    @procedures = {}
    #separar la cadena por proceso y maquina
    @route_all.split(",").each_with_index do |route,index|
      detail = route.split("-")
      #@procedures[detail.first] = detail.last
      #si el proceso es 3 evalua con el campo press, ya que las maquinas de tipo prensa estan creadas con 2 nombres distintos
      if detail.first == '3'
        machine = Machine.find_by(press:detail.last)
      else
        machine = Machine.find_by(name:detail.last)
      end  
      
      #validar que cada maquina tengan standard creado
      standard = Standard.find_by(machine_id:machine)
      if standard.nil?
        @order.errors.add(:subprocesses,"No hay estandar para la maquina #{detail.last}")
      else
        @procedures[detail.first] = standard
      end
    end
    #si no hay errores cree los subprocesos
    unless @order.errors.any?
      @order.create_subprocesses @procedures
      #lo envio a orders/:id
      redirect_to schedule_order_path(@order)
    end
    
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
      params.require(:order).permit(:state, :weight, :repeat, :route_id, :scheduled_meters, :date_offer, :outsourced_id, :outsourced_name, :outsourced_tolerance_down, :outsourced_tolerance_up, :order_date_request, :order_number, :order_quantity, :order_type, :order_um, :order_unit_value, :sheet_caliber, :sheet_client, :sheet_composite, :sheet_cut_type, :sheet_film, :sheet_guillotine, :sheet_height, :sheet_height_planned, :sheet_id, :sheet_meters_roll, :sheet_number, :sheet_print, :sheet_product_type, :sheet_route, :sheet_spaces, :sheet_version, :sheet_width)
    end
end

class DaysController < ApplicationController
  before_action :set_day, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  
  # GET /days
  # GET /days.json
  def index
    @days = Day.all.order(:day)
  end

  # GET /days/1
  # GET /days/1.json
  def show
    @subprocesses = @day.subprocesses
  end

  # GET /days/new
  def new
    @day = Day.new
    if params[:ref]
      @machine_id = params[:ref]
    end
    
  end

  # GET /days/1/edit
  def edit
  end

  # POST /days
  # POST /days.json
  def create
    @day = Day.new(day_params)

    respond_to do |format|
      if @day.save
        format.html { redirect_to schedule_days_path(@day.machine_id,start_date:@day.day) ,notice: 'Dia habilitado correctamente.' }
        format.json { render :show, status: :created, location: @day }
      else
        format.html { render :new }
        format.json { render json: @day.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /days/1
  # PATCH/PUT /days/1.json
  def update
    respond_to do |format|
      if @day.update(day_params)
        format.html { redirect_to @day, notice: 'Day was successfully updated.' }
        format.json { render :show, status: :ok, location: @day }
      else
        format.html { render :edit }
        format.json { render json: @day.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /days/1
  # DELETE /days/1.json
  def destroy
    @day.destroy
    respond_to do |format|
      format.html { redirect_to @day.machine, notice: 'Dia correctamente eliminado' }
      format.json { head :no_content }
    end
  end
  def schedule
    @machine = Machine.find(params[:machine_id])
    @days = @machine.days
    @day = Day.new
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_day
      @day = Day.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def day_params
      params.require(:day).permit(:init_time, :machine_id, :day, :shifts, :hours, :busy, :available)
    end
end

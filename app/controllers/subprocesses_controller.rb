class SubprocessesController < ApplicationController
  before_action :set_subprocess, only: [:show, :edit, :update, :destroy, :move_machine]
  skip_before_action :verify_authenticity_token
  load_and_authorize_resource

  # GET /subprocesses
  # GET /subprocesses.json
  def index
    @subprocesses = Subprocess.all.order(:start_date)
  end
  # GET /subprocesses_machine
  # GET /subprocesses_machine.json
  def by_machine
    @subprocesses = Machine.find(params[:machine_id]).subprocesses.scheduled.order(:start_date)
    render 'index'
  end

  # GET /subprocesses/1
  # GET /subprocesses/1.json
  def show
  end

  # GET /subprocesses/new
  def new
    @subprocess = Subprocess.new
  end

  # GET /subprocesses/1/edit
  def edit
  end

  # POST /subprocesses
  # POST /subprocesses.json
  def create
    @subprocess = Subprocess.new(subprocess_params)

    respond_to do |format|
      if @subprocess.save
        format.html { redirect_to @subprocess, notice: 'Subprocess was successfully created.' }
        format.json { render :show, status: :created, location: @subprocess }
      else
        format.html { render :new }
        format.json { render json: @subprocess.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subprocesses/1
  # PATCH/PUT /subprocesses/1.json
  def update
    respond_to do |format|
      if @subprocess.update(subprocess_params)
        format.html { redirect_to @subprocess, notice: 'Subprocess was successfully updated.' }
        format.json { render :show, status: :ok, location: @subprocess }
      else
        format.html { render :edit }
        format.json { render json: @subprocess.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subprocesses/1
  # DELETE /subprocesses/1.json
  def destroy
    @subprocess.destroy
    respond_to do |format|
      format.html { redirect_to subprocesses_url, notice: 'Subprocess was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /subprocesses/1/move_machine/2.json
  def move_machine
    @machine = Machine.find(params[:machine_id])

    today = DateTime.now.strftime('%F')
    last_day_machine = @machine.days.order(:day).last

    if  last_day_machine.day.strftime('%F') > today 
      @subprocess.update(standard_id:@machine.standards.first.id,day_id:last_day_machine.id)
    else
      @machine.errors.add(:status,"no hay dias disponibles")
      @machine.errors.add(:status,"Habilitar un nuevo dia mayor a #{today}")
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subprocess
      @subprocess = Subprocess.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subprocess_params
      params.require(:subprocess).permit(:order_id, :procedure_id, :standard_id, :day_id, :minutes, :setup_time, :start_date, :end_date, :meter, :sequence, :state,:quantity_finished)
    end
end

class LeftoversController < ApplicationController
  before_action :set_leftover, only: [:show, :edit, :update, :destroy]
  before_action :set_list_form, only: [:new,:edit]
  load_and_authorize_resource
  
  # GET /leftovers
  # GET /leftovers.json
  def index
    @leftovers = Leftover.all
  end

  def by_sheet
    @leftovers = Leftover.where(sheet_id:params[:sheet_id]).availables
    render 'index'
  end

  # GET /leftovers/1
  # GET /leftovers/1.json
  def show
    @has_leftovers = @leftover.has_leftovers
  end

  # GET /leftovers/new
  def new
    @leftover = Leftover.new
  end

  # GET /leftovers/1/edit
  def edit
  end

  # POST /leftovers
  # POST /leftovers.json
  def create
    @leftover = current_user.leftovers.new(leftover_params)

    respond_to do |format|
      if @leftover.save
        format.html { redirect_to @leftover, notice: 'Leftover was successfully created.' }
        format.json { render :show, status: :created, location: @leftover }
      else
        format.html { render :new }
        format.json { render json: @leftover.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leftovers/1
  # PATCH/PUT /leftovers/1.json
  def update
    respond_to do |format|
      if @leftover.update(leftover_params)
        format.html { redirect_to @leftover, notice: 'Leftover was successfully updated.' }
        format.json { render :show, status: :ok, location: @leftover }
      else
        format.html { render :edit }
        format.json { render json: @leftover.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leftovers/1
  # DELETE /leftovers/1.json
  def destroy
    @leftover.destroy
    respond_to do |format|
      format.html { redirect_to leftovers_url, notice: 'Leftover was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list_form
      @states = [{"name":"DISPONIBLE"},{"name":"OBSOLETO"}]
      @hometowns = [{"name":"PRODUCCION"},{"name":"SEGREGADO"},{"name":"INVENTARIO"}]
      @dispositions = [{"name":"SOBRANTES"},{"name":"MOLINO"}]
    end
    def set_leftover
      @leftover = Leftover.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leftover_params
      params.require(:leftover).permit(:quantity, :um, :weight, :location, :order_origin, :sheet_id,:sheet_code, :sheet_version, :entry_date, :disposition, :sheet_composite, :place_origin, :state,:observation)
    end
end

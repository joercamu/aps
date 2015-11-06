require 'test_helper'

class SubprocessesControllerTest < ActionController::TestCase
  setup do
    @subprocess = subprocesses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subprocesses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subprocess" do
    assert_difference('Subprocess.count') do
      post :create, subprocess: { end_time: @subprocess.end_time, meter: @subprocess.meter, minutes: @subprocess.minutes, order_id: @subprocess.order_id, procedure_id: @subprocess.procedure_id, sequence: @subprocess.sequence, standard_id: @subprocess.standard_id, start_date: @subprocess.start_date, state: @subprocess.state }
    end

    assert_redirected_to subprocess_path(assigns(:subprocess))
  end

  test "should show subprocess" do
    get :show, id: @subprocess
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subprocess
    assert_response :success
  end

  test "should update subprocess" do
    patch :update, id: @subprocess, subprocess: { end_time: @subprocess.end_time, meter: @subprocess.meter, minutes: @subprocess.minutes, order_id: @subprocess.order_id, procedure_id: @subprocess.procedure_id, sequence: @subprocess.sequence, standard_id: @subprocess.standard_id, start_date: @subprocess.start_date, state: @subprocess.state }
    assert_redirected_to subprocess_path(assigns(:subprocess))
  end

  test "should destroy subprocess" do
    assert_difference('Subprocess.count', -1) do
      delete :destroy, id: @subprocess
    end

    assert_redirected_to subprocesses_path
  end
end

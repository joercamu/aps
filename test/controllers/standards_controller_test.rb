require 'test_helper'

class StandardsControllerTest < ActionController::TestCase
  setup do
    @standard = standards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:standards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create standard" do
    assert_difference('Standard.count') do
      post :create, standard: { index: @standard.index, machine_id: @standard.machine_id, per_hour: @standard.per_hour, um: @standard.um, waste: @standard.waste }
    end

    assert_redirected_to standard_path(assigns(:standard))
  end

  test "should show standard" do
    get :show, id: @standard
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @standard
    assert_response :success
  end

  test "should update standard" do
    patch :update, id: @standard, standard: { index: @standard.index, machine_id: @standard.machine_id, per_hour: @standard.per_hour, um: @standard.um, waste: @standard.waste }
    assert_redirected_to standard_path(assigns(:standard))
  end

  test "should destroy standard" do
    assert_difference('Standard.count', -1) do
      delete :destroy, id: @standard
    end

    assert_redirected_to standards_path
  end
end

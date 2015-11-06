require 'test_helper'

class LeftoversControllerTest < ActionController::TestCase
  setup do
    @leftover = leftovers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:leftovers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create leftover" do
    assert_difference('Leftover.count') do
      post :create, leftover: { disposition: @leftover.disposition, entry_date: @leftover.entry_date, location: @leftover.location, order_origin: @leftover.order_origin, place_origin: @leftover.place_origin, quantity: @leftover.quantity, sheet_composite: @leftover.sheet_composite, sheet_id: @leftover.sheet_id, sheet_version: @leftover.sheet_version, state: @leftover.state, um: @leftover.um, weight: @leftover.weight }
    end

    assert_redirected_to leftover_path(assigns(:leftover))
  end

  test "should show leftover" do
    get :show, id: @leftover
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @leftover
    assert_response :success
  end

  test "should update leftover" do
    patch :update, id: @leftover, leftover: { disposition: @leftover.disposition, entry_date: @leftover.entry_date, location: @leftover.location, order_origin: @leftover.order_origin, place_origin: @leftover.place_origin, quantity: @leftover.quantity, sheet_composite: @leftover.sheet_composite, sheet_id: @leftover.sheet_id, sheet_version: @leftover.sheet_version, state: @leftover.state, um: @leftover.um, weight: @leftover.weight }
    assert_redirected_to leftover_path(assigns(:leftover))
  end

  test "should destroy leftover" do
    assert_difference('Leftover.count', -1) do
      delete :destroy, id: @leftover
    end

    assert_redirected_to leftovers_path
  end
end

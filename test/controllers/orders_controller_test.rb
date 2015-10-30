require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, order: { date_offer: @order.date_offer, order_date_request: @order.order_date_request, order_number: @order.order_number, order_quantity: @order.order_quantity, order_type: @order.order_type, order_um: @order.order_um, order_unit_value: @order.order_unit_value, outsourced_id: @order.outsourced_id, outsourced_name: @order.outsourced_name, outsourced_tolerance_down: @order.outsourced_tolerance_down, outsourced_tolerance_up: @order.outsourced_tolerance_up, repeat: @order.repeat, route_id: @order.route_id, scheduled_meters: @order.scheduled_meters, sheet_caliber: @order.sheet_caliber, sheet_client: @order.sheet_client, sheet_composite: @order.sheet_composite, sheet_cut_type: @order.sheet_cut_type, sheet_film: @order.sheet_film, sheet_guillotine: @order.sheet_guillotine, sheet_height: @order.sheet_height, sheet_height_planned: @order.sheet_height_planned, sheet_id: @order.sheet_id, sheet_meters_roll: @order.sheet_meters_roll, sheet_number: @order.sheet_number, sheet_print: @order.sheet_print, sheet_product_type: @order.sheet_product_type, sheet_route: @order.sheet_route, sheet_spaces: @order.sheet_spaces, sheet_version: @order.sheet_version, sheet_width: @order.sheet_width, state: @order.state, weight: @order.weight }
    end

    assert_redirected_to order_path(assigns(:order))
  end

  test "should show order" do
    get :show, id: @order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order
    assert_response :success
  end

  test "should update order" do
    patch :update, id: @order, order: { date_offer: @order.date_offer, order_date_request: @order.order_date_request, order_number: @order.order_number, order_quantity: @order.order_quantity, order_type: @order.order_type, order_um: @order.order_um, order_unit_value: @order.order_unit_value, outsourced_id: @order.outsourced_id, outsourced_name: @order.outsourced_name, outsourced_tolerance_down: @order.outsourced_tolerance_down, outsourced_tolerance_up: @order.outsourced_tolerance_up, repeat: @order.repeat, route_id: @order.route_id, scheduled_meters: @order.scheduled_meters, sheet_caliber: @order.sheet_caliber, sheet_client: @order.sheet_client, sheet_composite: @order.sheet_composite, sheet_cut_type: @order.sheet_cut_type, sheet_film: @order.sheet_film, sheet_guillotine: @order.sheet_guillotine, sheet_height: @order.sheet_height, sheet_height_planned: @order.sheet_height_planned, sheet_id: @order.sheet_id, sheet_meters_roll: @order.sheet_meters_roll, sheet_number: @order.sheet_number, sheet_print: @order.sheet_print, sheet_product_type: @order.sheet_product_type, sheet_route: @order.sheet_route, sheet_spaces: @order.sheet_spaces, sheet_version: @order.sheet_version, sheet_width: @order.sheet_width, state: @order.state, weight: @order.weight }
    assert_redirected_to order_path(assigns(:order))
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, id: @order
    end

    assert_redirected_to orders_path
  end
end

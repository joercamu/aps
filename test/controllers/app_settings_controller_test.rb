require 'test_helper'

class AppSettingsControllerTest < ActionController::TestCase
  setup do
    @app_setting = app_settings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_settings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create app_setting" do
    assert_difference('AppSetting.count') do
      post :create, app_setting: { blocked_days: @app_setting.blocked_days, days_back: @app_setting.days_back }
    end

    assert_redirected_to app_setting_path(assigns(:app_setting))
  end

  test "should show app_setting" do
    get :show, id: @app_setting
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @app_setting
    assert_response :success
  end

  test "should update app_setting" do
    patch :update, id: @app_setting, app_setting: { blocked_days: @app_setting.blocked_days, days_back: @app_setting.days_back }
    assert_redirected_to app_setting_path(assigns(:app_setting))
  end

  test "should destroy app_setting" do
    assert_difference('AppSetting.count', -1) do
      delete :destroy, id: @app_setting
    end

    assert_redirected_to app_settings_path
  end
end

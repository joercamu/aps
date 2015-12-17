class AddDataToAppSettings < ActiveRecord::Migration
  def change
  	AppSetting.create()
  end
end

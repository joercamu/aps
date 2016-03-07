class AddRecipientsToAppSetting < ActiveRecord::Migration
  def change
    add_column :app_settings, :recipients, :text
  end
end

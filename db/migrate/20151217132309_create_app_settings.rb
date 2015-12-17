class CreateAppSettings < ActiveRecord::Migration
  def change
    create_table :app_settings do |t|
      t.integer :blocked_days, default:3
      t.integer :days_back,default:1

      t.timestamps null: false
    end
  end
end

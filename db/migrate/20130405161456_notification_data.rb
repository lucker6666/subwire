class NotificationData < ActiveRecord::Migration
  def change
    add_column :notifications, :data1, :string, null: true
    add_column :notifications, :data2, :string, null: true
  end
end

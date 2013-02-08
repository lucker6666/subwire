class RemoveNotifications < ActiveRecord::Migration
  def change
    drop_table :notifications
  end
end

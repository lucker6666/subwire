class NotificationCreatedBy < ActiveRecord::Migration
  def change
    add_column :notifications, :created_by, :integer
  end
end

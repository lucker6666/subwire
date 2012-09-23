class MailNotification < ActiveRecord::Migration
  def change
    add_column :relationships, :mail_notification, :boolean, :default => true
    add_column :users, :last_activity, :datetime, :default => Time.now
  end
end

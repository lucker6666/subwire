class AddShowLoginStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :show_login_status, :boolean, :default => true
  end
end

class Invitation < ActiveRecord::Migration
  def change
    add_column :users, :invitation_pending, :boolean, default: false
  end
end

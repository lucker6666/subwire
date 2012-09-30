class Recoverable < ActiveRecord::Migration
  def change
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime

    add_index :users, :reset_password_token, unique: true
  end
end

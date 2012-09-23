class UsersColors < ActiveRecord::Migration
  def change
    add_column :users, :color, :string, :null => false, :default => '000'
  end
end

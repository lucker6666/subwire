class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :name, :null => false, :default => ''
      t.string :email, :null => false, :default => ''
      t.boolean :is_admin, :null => false, :default => false

      ## Database authenticatable
      t.string :login,              :null => false, :default => ''
      t.string :encrypted_password, :null => false, :default => ''

      ## Rememberable
      t.datetime :remember_created_at

      t.timestamps
    end

    add_index :users, :login,                :unique => true
  end
end

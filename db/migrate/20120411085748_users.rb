class Users < ActiveRecord::Migration
  def change
  	create_table :users do |t|
      t.string :login
      t.string :email
      t.string :name
      t.string :password_digest
      t.boolean :is_admin

      t.timestamps
    end
  end
end

class Recoverable < ActiveRecord::Migration
	def change
	  change_table(:users) do |t|
	    t.confirmable
	  end

  	add_index :users, :reset_password_token, :unique => true
  	add_index :users, :authentication_token, :unique => true
	end
end

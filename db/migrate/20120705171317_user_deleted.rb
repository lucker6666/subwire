class UserDeleted < ActiveRecord::Migration
	def change
		add_column :users, :is_deleted, :boolean, :default => false
		remove_column :users, :superadmin, :color
	end
end

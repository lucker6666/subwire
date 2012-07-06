class RefactorNotification < ActiveRecord::Migration
	def change
		add_column :notifications, :provokesUser, :integer
		add_column :notifications, :subject, :string
		remove_column :notifications, :message 
	end
end

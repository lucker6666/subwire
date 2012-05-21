class Notification < ActiveRecord::Base
	attr_accessible :notification_type, :message, :href, :is_read, :user

	belongs_to :user
	belongs_to :instance
end

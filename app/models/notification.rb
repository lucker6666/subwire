class Notification < ActiveRecord::Base
	attr_accessible :type, :message, :href, :is_read, :user

	belongs_to :user
end

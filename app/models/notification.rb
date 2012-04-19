class Notification < ActiveRecord::Base
	attr_accessible :type, :message, :href, :is_read, :usser

	belongs_to :user
end

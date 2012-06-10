class Notification < ActiveRecord::Base
	attr_accessible :notification_type, :message, :href, :is_read, :user, :instance

	belongs_to :user
	belongs_to :instance

	def self.notify_all_users(data, instance, current_user)
		Relationship.find_all_users_by_instance(instance).each do |user|
			unless user == current_user
				notification = Notification.new({
					:notification_type => data[:notification_type],
					:message => data[:message],
					:href => data[:href],
					:is_read => false,
					:user => user,
					:instance => instance
				})

				notification.save
			end
		end
	end
end

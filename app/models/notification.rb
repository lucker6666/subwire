#   Schema
# ==========
# 	table: notifications
#
# 	notification_id			:integer		not null, primary key
# 	user_id							:integer
# 	instance_id					:integer		not null, index
# 	notification_type		:string			default => "article"
# 	message							:string
# 	href								:string
# 	is_read							:boolean
# 	created_at					:datetime		not null
# 	updated_at					:datetime		not null
#
# TODO: index for instance_id
# TODO: index for user_id
# TODO: not null user_id, notification_type


class Notification < ActiveRecord::Base
	### Attributes
	attr_accessible :notification_type, :message, :href

	### Associations
	belongs_to :user
	belongs_to :instance

	### Validations
	# Make sure, notification_type, message, href, is_read are not empty
	validates :notification_type, :message, :href, :is_read, :presence => true


	### Methods

	def self.notify_all_users(data, instance, current_user)
		Relationship.find_all_users_by_instance(instance).each do |user|
			unless user == current_user
				notification = Notification.new({
					:notification_type => data[:notification_type],
					:message => data[:message],
					:href => data[:href]
				})

				notification.is_read = false
				notification.user = user
				notification.instance = instance

				notification.save
			end
		end
	end
end

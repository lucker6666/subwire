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
	attr_accessible :notification_type, :provokesUser, :subject, :href, :created_by

	### Associations
	belongs_to :user
	belongs_to :user, :foreign_key => "created_by"
	belongs_to :instance

	### Validations
	# Make sure, notification_type, message, href, is_read are not empty
	validates :notification_type, :created_by, :href, :presence => true


	### Methods

	def self.notify_all_users(data, instance, current_user, options = {})
		except = options[:except] || []

		Relationship.find_all_users_by_instance(instance).each do |user|
			unless user == current_user or except.include?(user)
				notification = Notification.new({
					:notification_type => data[:notification_type],
					:provokesUser => data[:provokesUser],
					:subject => data[:subject],
					:href => data[:href],
					:created_by => current_user
				})

				notification.is_read = false
				notification.user = user
				notification.instance = instance

				notification.save
			end
		end
	end

	def avatar_path
		User.find(self.provokesUser).avatar.url
	end

	def message
		"<strong>" + I18n.t("notifications." + self.notification_type, user: User.find(self.provokesUser).name) + "</strong> <br />#{self.subject}"
	end

	def read!
		self.is_read = true
		self.save
	end

	# Returns an array of notifications for an user and an instance
	def self.find_all_relevant(instance, user)
		return if instance.nil?


			notifications = order("is_read").order("created_at DESC").limit(5).where(
			:user_id => user.id,
			:instance_id => instance.id
			)

		if notifications.nil?
			notifications = []
		end

		notifications
	end
end

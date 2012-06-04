module NotificationsHelper
	# Returns the icon for a notification
	def notification_icon(notification)
		icon = "file"

		case notification.notification_type.to_sym
			when :edit_article
				icon = "pencil"
			when :new_comment
				icon = "comment"
			when :new_calendar
				icon = "calendar"
		end

		return "<i class=\"icon-#{icon}\"></i>".html_safe
	end

	# Returns an array of notifications for the current user
	def notifications
		if @notifications.nil?
			@notifications = Notification.where(
				:user_id => current_user.id,
				:instance_id => current_instance.id
			)

			if @notifications.nil?
				@notifications = []
			end
		end

		@notifications
	end
end

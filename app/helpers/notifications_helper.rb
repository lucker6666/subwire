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
	def all_notifications
		if current_instance.nil?
					@all_notifications_cached = []
		else
			if @all_notifications_cached.nil?
				@all_notifications_cached = Notification.order("is_read").where(
					:user_id => current_user.id,
					:instance_id => current_instance.id
				)

				if @all_notifications_cached.nil?
					@all_notifications_cached = []
				end
			end

			@all_notifications_cached
		end
	end
end

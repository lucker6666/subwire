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
end

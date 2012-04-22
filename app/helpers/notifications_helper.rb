module NotificationsHelper
	def notification_icon(notification)
		icon = "file"

		case notification.type.internal
			when :edit_article
				icon = "pencil"
			when :new_comment
				icon = "comment"
			when :new_calendar
				icon = "calendar"
		end

		return "<i class=\"icon-#{icon}\"></i>"
	end
end

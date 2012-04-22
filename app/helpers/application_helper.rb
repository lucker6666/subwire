module ApplicationHelper
	def colored_name(user)
		"<span style='color: \##{user.color};'>#{user.name}</span>".html_safe
	end

	def notifications
		if @notifications.nil?
			@notifications = Notification.find_all_by_user_id(current_user.id)

			if @notifications.nil?
				@notifications = []
			end
		end

		@notifications
	end
end

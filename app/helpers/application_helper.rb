module ApplicationHelper
	include Session

	# Returns the colored user name
	def colored_name(user)
		"<strong style='color: \##{user.color};'>#{user.name}</strong>".html_safe
	end

	# Returns true if ad banner should be displayed
	def display_ads
		if current_user.is_admin?
			false
		end

		current_instance.advertising
	end
end

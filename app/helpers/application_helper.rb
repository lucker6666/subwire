module ApplicationHelper
	# Returns the colored user name
	def colored_name(user)
		"<strong style='color: \##{user.color};'>#{user.name}</strong>".html_safe
	end
end

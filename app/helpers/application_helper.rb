module ApplicationHelper
	def colored_name(user)
		"<span style='color: \##{user.color};'>#{user.name}</span>".html_safe
	end
end

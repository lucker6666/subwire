module ApplicationHelper
	# Returns the colored user name
	def colored_name(user)
		"<strong style='color: \##{user.color};'>#{user.name}</strong>".html_safe
	end

	# Return true if the current user is admin of the current instance
	def is_admin_of_instance?
		rel = Relationship.where(:user_id => current_user.id, :instance_id => current_instance.id).first
		rel.admin?
	end
end

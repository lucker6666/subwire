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

	def current_instance
		session[:instance]
	end

	def display_ads
		if current_user.is_admin?
  		return false
  	end

		current_instance.advertising
	end
end

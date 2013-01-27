# Module to provide current_ methods for several parts of the rails application
module Session
  # returns the current_channel from session or nil if no channel was choosen
  def current_channel
    session[:channel]
  end

  # Sets the current channel of current user
  def set_current_channel(channel)
    session[:channel] = channel
  end

  # Returns the relationship between current_user ans current_channel
  def current_rs
    Relationship.where(
      user_id: current_user.id,
      channel_id: current_channel.id
    ).first
  end

  # Checks if user has admin privileges for the current channel
  def has_admin_privileges?
    has_superadmin_privileges? || current_rs.admin?
  end

  # Checks if user has super admin privileges
  def has_superadmin_privileges?
    current_user.is_admin?
  end
end

ActionController::Base.send :include, Session
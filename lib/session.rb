# Module to provide current_... methods for several parts of the rails application
module Session
  # returns the current_instance from session or nil if no instance was choosen
  def current_instance
    session[:instance]
  end

  # Sets the current instance of current user
  def set_current_instance(instance)
    session[:instance] = instance
  end

  # Returns the relationship between current_user ans current_instance
  def current_rs
    Relationship.where(
      user_id: current_user.id,
      instance_id: current_instance.id
    ).first
  end

  def has_admin_privileges?
    has_superadmin_privileges? || current_rs.admin?
  end

  def has_superadmin_privileges?
    current_user.is_admin?
  end
end

ActionController::Base.send :include, Session
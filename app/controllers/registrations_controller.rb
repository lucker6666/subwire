class RegistrationsController < Devise::RegistrationsController
	def after_inactive_sign_up_path_for(resource)
    "/inactive"
  end

  def new
  end

  def create
  	render :new
  end

  def edit
  end
end
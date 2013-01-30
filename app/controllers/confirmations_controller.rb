class ConfirmationsController < Devise::ConfirmationsController
  ### Methods

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      if resource.invitation_pending
        sign_in(resource)
        redirect_to "/users/finish"
      else
        redirect_to "/"
      end
    end
  end
end
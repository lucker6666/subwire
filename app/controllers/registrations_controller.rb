class RegistrationsController < Devise::RegistrationsController
  def after_inactive_sign_up_path_for(resource)
    "/inactive"
  end

  def new
    super
  end

  def create
    build_resource

    #Exist deleted user with this mailadress?
    @user = User.where(:email => resource.email, :is_deleted => true)

    if(@user.length > 0)
      @user.each do |u|
        u.update_attributes(params[:user])
        u.is_deleted = false
        u.save
        sign_in(u)
      end

      redirect_to "/instances"
    else
      super
    end
  end

  def edit
    super
  end
end
class UsersController < ApplicationController
  # PUT /users/:id
  def update
    @user = User.find(params[:id])
    authorize! :edit, @user

    @relationships = Relationship.where(user_id: @user.id)

    # Delete the email param
    params[:user].delete :email

    if params[:user][:password].empty?
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end

    # Relationships
    @relationships.each do |relationship|
      relationship.mail_notification = params['rel' + relationship.id.to_s]
      relationship.save
    end

    @user.show_login_status = params[:show_login_status]

    # Gravatar
    if !@user.gravatar && params[:gravatar]
      @mail = @user.email
      @mail.strip!
      @user.gravatar = Digest::MD5.hexdigest(@mail.downcase)
      @user.save
    elsif !params[:gravatar] && @user.gravatar
      @user.gravatar = nil
      @user.save
    end

    if @user.update_attributes(params[:user])
      if can?(:admin, :all)
        @user.is_admin = params[:is_admin]
        @user.save
      else
        sign_in(@user, bypass: true)
      end

      feedback t('users.updated')
      redirect_to user_path(@user)
    else
      render action: :edit
    end
  end
end
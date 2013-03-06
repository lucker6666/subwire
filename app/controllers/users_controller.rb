class UsersController < ApplicationController
  before_filter :load_user, only: [:show, :edit, :update, :destory]
  skip_filter :finish_invitation, only: [:finish, :finish_save]

  # GET /users
  def index
    @users = User.find_all_active_by_page params[:page]
  end


  # GET /users/1
  def show
    @assignedCount = Relationship.where(user_id: @user.id).length
    @adminCount = Relationship.where(user_id: @user.id, admin: true).length
    @messagesCount = Message.where(user_id: @user.id).length
    @commentsCount = Comment.where(user_id: @user.id).length
  end


  # GET /users/edit/:id
  def edit
    @relationships = Relationship.where(user_id:@user.id)
  end


  # PUT /users/:id
  def update
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

    # If the user has changed his name, notify the users to prevent identity theft
    if params[:user][:name] != @user.name
      @user.relationships.each do |rel|
        Notification.notify_all_users({
          notification_type: :username_change,
          provokesUser: @user,
          href: user_path(@use)
        }, @rel.channel, current_user)
      end
    end

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


  # DELETE /users/:id
  def destroy
    # Check channels of the User
    Relationship.where(user_id: @user.id, admin: true).each do |o|
      @userInChannel = Relationship.find_all_users_by_channel(o)

      if(@userInChannel.length > 1)
        # Another Admin in this Channel?
        if(@userInChannel.where(is_admin: true).length < 2)
          feedback "You have an Channel with no other Admin!"
          redirect_to :back
        end
      else
        # Delete the Channel
        Channel.find(o.channel_id).destroy
      end
    end

    # Delete associated
    @notifications = Notification.find_all_by_user_id(@user.id).destroy_all
    @relationships = Relationship.where(user_id: @user.id).destroy_all

    # Destroy the user not really, set only a flag
    @user.is_deleted = true
    @user.save

    # End session
    unless can? :admin, :all
      sign_out(current_user)
    end

    feedback t('users.destroyed')
    redirect_to :back
  end


  # Finish invitation
  def finish
    if current_user.invitation_pending
      @user = User.find(current_user.id)
      @user.name = ""
      render :finish, layout: "login"
    else
      redirect_to "/"
    end
  end


  # Finish a finishing invitation
  def finish_save
    @user = current_user

    if @user.update_attributes(params[:user])
      @user.invitation_pending = false
      @user.save

      feedback t('users.invitation_finished')
      redirect_to "/"
    else
      errors_to_feedback @user
      render :finish, layout: "login"
    end
  end


  private

    def load_user
      @user = User.find(params[:id])
      authorize! :read, @user
    end
end
class UsersController < ApplicationController
  before_filter :load_user, only: [:show, :edit, :update, :destory]
  skip_filter :finish_invitation, only: [:finish, :finish_save]

  # GET /users
  def index
    authorize! :manage, User
    @users = User.find_all_active_by_page params[:page]
  end


  # GET /users/1
  def show
    # Set all notifications regarding that user as read
    @notifications = current_user.notifications.where(
      is_read: false,
      href: user_path(@user)
    ).each { |n| n.read! }

    # Update the notifications of the user
    load_notifications

    @assignedCount = Relationship.where(user_id: @user.id).length
    @adminCount = Relationship.where(user_id: @user.id, admin: true).length
    @messagesCount = Message.where(user_id: @user.id).length
    @commentsCount = Comment.where(user_id: @user.id).length
    @canInvite = @current_user.can_invite_user_to_channels(@user)
  end


  # GET /users/edit/:id
  def edit
    authorize! :update, @user

    @relationships = Relationship.where(user_id: @user.id)
  end


  # PUT /users/:id
  def update
    authorize! :update, @user

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
      relationship.save!
    end

    @user.show_login_status = params[:show_login_status]

    # Gravatar
    if !@user.gravatar && params[:gravatar]
      @mail = @user.email
      @mail.strip!
      @user.gravatar = Digest::MD5.hexdigest(@mail.downcase)
      @user.save!
    elsif !params[:gravatar] && @user.gravatar
      @user.gravatar = nil
      @user.save!
    end

    old_name = @user.name

    if @user.update_attributes(params[:user])
      if can?(:admin, :all)
        @user.is_admin = params[:is_admin]
        @user.save!
      else
        sign_in(@user, bypass: true)
      end

      # If the user has changed his name, notify the users to prevent identity theft
      if params[:user][:name] != old_name
        @user.relationships.each do |rel|
          Notification.notify_all_users({
            notification_type: :username_change,
            provokesUser: @user,
            subject: "",
            href: user_path(@user),
            data: [old_name]
          }, rel.channel, current_user)
        end
      end

      feedback t('users.updated'), :success
      redirect_to user_path(@user)
    else
      render action: :edit
    end
  end


  # DELETE /users/:id
  def destroy
    authorize! :destroy, @user

    # Check channels of the User
    Relationship.where(user_id: @user.id, admin: true).each do |o|
      @userInChannel = Relationship.find_all_users_by_channel(o)

      if(@userInChannel.length > 1)
        # Another Admin in this Channel?
        if(@userInChannel.where(is_admin: true).length < 2)
          # TODO translate
          feedback "You have an Channel with no other Admin!", :error
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
    @user.save!

    # End session
    unless can? :admin, :all
      sign_out(current_user)
    end

    feedback t('users.destroyed'), :success
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
      @user.save!

      feedback t('users.invitation_finished'), :success
      redirect_to "/"
    else
      errors_to_feedback @user
      render :finish, layout: "login"
    end
  end
  
  def invite_user
    @user = User.find(params[:id])
    @channel = Channel.find(params[:channel])
    if Relationship.is_user_admin_of_channel?(current_user, @channel) && !Relationship.exists?(@channel, @user)
        @relationship = Relationship.new

        @relationship.user = @user
        @relationship.channel = @channel
        @relationship.admin = false

        if @relationship.save
          Notification.notify_all_users({
            notification_type: :new_user,
            provokesUser: @user,
            subject: "",
            href: user_path(@user)
            }, @channel, current_user, except: [@user])

          feedback t('relationships.created'), :success 
        else
          feedback t('relationships.not_created'), :error
        end
    else
      feedback t('relationships.not_created'), :error
    end
    
    redirect_to :back
  end


  private

    def load_user
      @user = User.find(params[:id])
      authorize! :read, @user
    end
end
class RelationshipsController < ApplicationController
  before_filter :authenticate_user!, :choose_channel!, :check_permissions
  before_filter :restricted_to_admin, except: [:destroy]

  # GET /relationships
  def index
    @relationships = Relationship.find_all_by_channel_id_and_page(current_channel.id, params[:page])
  end

  # GET /relationships/new
  def new
    @relationship = Relationship.new
  end

  # GET /relationships/1/edit
  def edit
    @relationship = Relationship.find(params[:id])
  end

  # POST /relationships
  def create
    @relationship = Relationship.new

    user = User.find_by_email(params[:relationship][:email])

    unless user
      password =
      user = User.new
      user.name = "unkown"
      user.email = params[:relationship][:email]
      user.password = Digest::MD5.hexdigest(Random.rand(10000).to_s)
      user.timezone = current_user.timezone
      user.lang = current_channel.defaultLanguage
      user.invitation_pending = true
      user.skip_confirmation!
      user.confirmation_token = User.confirmation_token
      user.confirmation_sent_at = Time.now.utc

      unless user.save
        errors_to_feedback(user)
        render action: "new"
        return
      end

      rel = Relationship.new
      rel.user = user
      rel.channel = current_channel

      if has_admin_privileges?
        rel.admin = params[:relationship][:admin]
      end

      rel.save

      RelationshipMailer.invitation(user, current_user).deliver

      feedback t('relationships.invited')
      redirect_to relationships_path
    else
      #Wenn der Benutzer gelöscht ist soll er auch wieder eine "Einladung" bekommen
      if user.is_deleted
        user.password = Digest::MD5.hexdigest(Random.rand(10000).to_s)
        user.timezone = current_user.timezone
        user.invitation_pending = true
        user.skip_confirmation!
        user.confirmation_token = User.confirmation_token
        user.confirmation_sent_at = Time.now.utc
        user.is_deleted = false

        unless user.save
          errors_to_feedback(user)
          render action: "new"
          return
        end

        rel = Relationship.new
        rel.user = user
        rel.channel = current_channel

        if has_admin_privileges?
          rel.admin = params[:relationship][:admin]
        end

        rel.save

        RelationshipMailer.invitation(user, current_user).deliver

        feedback t('relationships.invited')
        redirect_to relationships_path
      else
        @relationship.user = user
        @relationship.channel = current_channel

        if has_admin_privileges?
          @relationship.admin = params[:relationship][:admin]
        end

        # TODO: Create User and send email, if doesn't exist

        @relationship.channel = current_channel

        if @relationship.save
          Notification.notify_all_users({
            notification_type: "new_user",
            provokesUser: user.id,
            subject: "",
            href: user_path(user)
          }, current_channel, current_user, except: [user])

          feedback t('relationships.created')
          redirect_to relationships_path(@article)
        else
          feedback t('relationships.not_created')
          render action: "new"
        end
      end
    end
  end


  # PUT /relationships/1
  def update
    if has_admin_privileges?
      @relationship = Relationship.find(params[:id])
      @relationship.admin = params[:relationship][:admin]
    else
      @relationship = current_user.relationships.find(params[:id])
    end

    params[:relationship].delete :admin

    if @relationship.update_attributes(params[:relationship])
      feedback t('relationships.updated')
      redirect_to relationships_path
    else
      render action: "edit"
    end
  end

  # DELETE /relationships/1
  def destroy
    if has_admin_privileges?
      @relationship = Relationship.find(params[:id])
    else
      @relationship = current_user.relationships.find(params[:id])
    end

    @channel = Channel.find(@relationship.channel)
    @userInChannel = Relationship.find_all_users_by_channel(@channel)

    if @userInChannel.length < 2

      @notifications = Notification.find_all_by_channel_id(@channel.id)

      @notifications.each do |n|
        n.destroy
      end

      @channel.destroy
      @relationship.destroy

      feedback t('relationships.destroyed')

      set_current_channel nil

      redirect_to channels_path
    else
      @relationship.destroy

      feedback t('relationships.destroyed')
      redirect_to "/"
    end
  end
end

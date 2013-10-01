class Channels::RelationshipsController < ApplicationController
  before_filter :load_channel
  before_filter :load_relationship, only: [:show, :edit, :destroy]
  before_filter :section


  # GET /channels/:id/relationships
  def index
    @relationships = Relationship.find_all_by_channel_id_and_page(
      current_channel.id,
      params[:page]
    )
  end


  # GET /channels/:id/relationships/new
  def new
    authorize! :create, Relationship
    @relationship = Relationship.new
    @inviteable = '["albert", "alles", "abc"]'
  end


  # GET /channels/:id/relationships/1/edit
  def edit
    authorize! :update, @relationship
  end


  # POST /channels/:id/relationships
  def create
    authorize! :create, Relationship

    user = User.find_by_email(params[:relationship][:email])

    if user.nil?
      user = User.new
      user.name = "unkown"
      user.email = params[:relationship][:email]
      invite_user(user)

      feedback t('relationships.invited'), :success
      redirect_to channel_relationships_path(current_channel)
    else
      relationship = Relationship.find_by_channel_and_user(current_channel, user)

      if !relationship.nil?
        feedback t('relationships.exist')
        redirect_to channel_relationships_path(current_channel)
      elsif user.is_deleted
        # If user is deleted, send an invitation anyway
        user.is_deleted = false
        invite_user(user)
      else
        @relationship = Relationship.new

        @relationship.user = user
        @relationship.channel = current_channel

        if can? :change, current_channel
          @relationship.admin = params[:relationship][:admin]
        end

        if @relationship.save
          Notification.notify_all_users({
            notification_type: :new_user,
            provokesUser: user,
            subject: "",
            href: user_path(user)
          }, current_channel, current_user, except: [user])

          feedback t('relationships.created'), :success
          redirect_to channel_relationships_path(current_channel)
        else
          feedback t('relationships.not_created'), :error
          render action: "new"
        end
      end
    end
  end


  # PUT /channels/:id/relationships/1
  def update
    if can? :update, current_channel
      @relationship.admin = params[:relationship][:admin]
    end

    params[:relationship].delete :admin

    if @relationship.update_attributes(params[:relationship])
      feedback t('relationships.updated'), :success
      redirect_to channel_relationships_path(current_channel)
    else
      render action: "edit"
    end
  end


  # DELETE /channels/:id/relationships/1
  def destroy
    authorize! :update, @relationship

    @channel = @relationship.channel
    @user_in_channel = Relationship.find_all_users_by_channel(@channel)

    if @user_in_channel.length < 2
      Notification.find_all_by_channel_id(@channel.id).destroy_all
      @relationship.destroy
    end

    @relationship.destroy
    feedback t('relationships.destroyed'), :success

    if @relationship.user == @current_user
      redirect_to "/"
    else
      redirect_to channel_relationships_path(current_channel)
    end
  end


  private

    # Find respective relationship
    def load_relationship
      @relationship = Relationship.find(params[:id])
      authorize! :read, @relationship
    end


    # Send an invitation so an user
    def invite_user(user)
      # Generate random password
      user.password = Digest::MD5.hexdigest(Random.rand(10000).to_s)

      # Timezone and language are taken from the current user
      user.timezone = @current_user.timezone
      user.lang = current_channel.defaultLanguage

      user.invitation_pending = true

      # Skip the confirmation stuff
      user.skip_confirmation!
      user.confirmation_token = User.confirmation_token
      user.confirmation_sent_at = Time.now.utc

      # Save user
      unless user.save
        errors_to_feedback(user)
        render action: "new"
        return
      end

      # Create relationship
      rel = Relationship.new
      rel.user = user
      rel.channel = current_channel

      rel.admin = false

      if can? :update, current_channel
        rel.admin = params[:relationship][:admin]
      end

      rel.save!

      # Send invitation Mail
      RelationshipMailer.invitation(user, current_user, params[:invitation_text]).deliver
    end

    def section
      set_section :members
    end
end
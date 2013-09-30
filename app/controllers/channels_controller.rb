class ChannelsController < ApplicationController
  before_filter :load_channels, only: [:index]

  # GET /channels
  def index
    authorize! :read, Channel
  end


  # GET /channels/:id
  def show
    redirect_to channel_messages_path(current_channel)
  end


  # GET /channels/new
  def new
    authorize! :create, Channel
    @channel = Channel.new
  end


  # GET /channels/:id/edit
  def edit
    authorize! :update, current_channel
    set_section :settings
  end


  # POST /channels
  def create
    authorize! :create, Channel

    # Advertising on/off setting - just for superadmins!
    advertising = can?(:disable_ads, Channel) ? params[:channel][:advertising] : true
    params[:channel].delete :advertising

    # Create channel, set advertising setting and save
    set_channel Channel.new(params[:channel])
    current_channel.advertising = advertising

    if current_channel.save
      # The relationship between current user and the new channel
      create_relationship
      create_wiki_home

      feedback t('channels.created'), :success
      redirect_to channel_path(current_channel)
    else
      # Couldn't save channel
      feedback t('channels.not_created'), :error
      errors_to_feedback(current_channel)
      render action: :new
    end
  end


  # PUT /channels/1
  def update
    authorize! :update, current_channel

    # Make sure that advertising is not set to false while user is not a superadmin
    current_channel.advertising = params[:channel][:advertising]
    if !params[:channel][:advertising].nil? && !can?(:disable_ads, current_channel)
      current_channel.advertising = true
    end

    params[:channel].delete :advertising

    # Update channel
    if current_channel.update_attributes(params[:channel])
      feedback t('channels.updated'), :success
    else
      feedback t('channels.not_updated'), :error
      errors_to_feedback(current_channel)
    end

    redirect_to channel_path(current_channel)
  end


  # DELETE /channels/1
  def destroy
    authorize! :destroy, current_channel

    current_channel.notifications.destroy_all
    current_channel.relationships.destroy_all
    current_channel.messages.destroy_all
    current_channel.destroy

    feedback t('channels.destroyed'), :success
    redirect_to channels_path
  end


  private

      def create_relationship
        rel = Relationship.new
        rel.user = current_user
        rel.channel = current_channel
        rel.admin = true
        rel.save!
      end

      def create_wiki_home
        wiki = Wiki.new
        wiki.user = current_user
        wiki.channel = current_channel
        wiki.is_home = true
        wiki.title = t('wiki.default_page.title')
        wiki.content = t('wiki.default_page.content')
        wiki.save!
      end
end
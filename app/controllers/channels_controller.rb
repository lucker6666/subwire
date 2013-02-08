class ChannelsController < ApplicationController
  before_filter :load_channel, only: [:show, :edit, :update, :destroy]
  before_filter :load_channels, only: [:index]

  # GET /channels
  def index
    authorize! :read, Channel
  end


  # GET /channels/:id
  def show
    authorize! :read, @channel
  end


  # GET /channels/new
  def new
    @channel = Channel.new
  end


  # GET /channels/:id/edit
  def edit
    authorize! :update, @channel
  end


  # POST /channels
  def create
    authorize! :create, Channel

    # Advertising on/off setting - just for superadmins!
    advertising = can?(:disable_ads, Channel) ? params[:channel][:advertising] : true
    params[:channel].delete :advertising

    # Create channel, set advertising setting and save
    @channel = Channel.new(params[:channel])
    @channel.advertising = advertising

    if @channel.save
      # The relationship between current user and the new channel
      rel = Relationship.new
      rel.user = current_user
      rel.channel = @channel
      rel.admin = true
      rel.save

      # Default message
      message = Message.new
      message.user = current_user
      message.channel = @channel
      message.title = t('messages.standard_title', locale: @channel.defaultLanguage)
      message.content = t('messages.standard_content', locale: @channel.defaultLanguage)
      message.save

      feedback t('channels.created')
      redirect_to channel_path(@channel)
    else
      # Couldn't save channel
      feedback t('channels.not_created')
      errors_to_feedback(@channel)
      render action: :new
    end
  end


  # PUT /channels/1
  def update
    authorize! :update, @channel

    # Make sure that advertising is not set to false while user is not a superadmin
    @channel.advertising = params[:channel][:advertising]
    if !params[:channel][:advertising].nil? && !can?(:disable_ads, @channel)
      @channel.advertising = true
    end

    params[:channel].delete :advertising

    # Update channel
    if @channel.update_attributes(params[:channel])
      feedback t('channels.updated')
    else
      feedback t('channels.not_updated')
      errors_to_feedback(@channel)
    end

    redirect_to channel_path(@channel)
  end


  # DELETE /channels/1
  def destroy
    authorize! :destroy, @channel

    @channel.notifications.destroy_all
    @channel.relationships.destroy_all
    @channel.messages.destroy_all
    @channel.destroy

    feedback t('channels.destroyed')
    redirect_to channels_path
  end


  private

    # Filter to load the requested channel
    def load_channel
      @channel = Channel.find_by_permalink(params[:id])
      authorize! :read, @channel
    end
end
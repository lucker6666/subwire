class ChannelsController < ApplicationController
  # User have to be logged in
  before_filter :authenticate_user!
  before_filter :restricted_to_superadmin, only: [:all]

  # GET /channel
  def index
    @channels = Channel.find(
      :all,
      joins: :relationships,
      conditions: { "relationships.user_id" => current_user.id }
    )

    # Required to check if user has reached the limit of channels
    @adminCount = Channel.find_all_where_user_is_admin(current_user).length

    @notificationCount = 0
    @channels.each do |channel|
      @notificationCount += channel.notification_count(current_user)
    end

    render 'index', layout: 'login'
  end

  # GET /channels/1
  def show
    set_current_channel Channel.find(params[:id])

    redirect_to articles_path
  end

  # GET /channels/new
  def new
    if !has_superadmin_privileges? && Channel.find_all_where_user_is_admin(current_user).length > 4
      feedback t('channels.hit_limit')
      redirect_to channels_path
    else
      @channel = Channel.new

      render 'new', layout: 'login'
    end
  end

  # GET /channels/1/edit
  def edit
    @channel = Channel.find(params[:id])

    unless has_superadmin_privileges? || Relationship.is_user_admin_of_channel?(current_user, @channel)
      feedback "Access denied!"
      redirect_to :back
    end

    render 'edit', layout: 'login'
  end

  # POST /channels
  def create
    if !has_superadmin_privileges? && Channel.find_all_where_user_is_admin(current_user).length > 4
      feedback t('channels.hit_limit')
      redirect_to :back
    else
      if has_superadmin_privileges?
        advertising = params[:channel][:advertising]
      else
        advertising = true
      end

      params[:channel].delete :advertising

      @channel = Channel.new(params[:channel])
      @channel.advertising = advertising

      if @channel.save
        rel = Relationship.new
        rel.user = current_user
        rel.channel = @channel
        rel.admin = true
        rel.save

        article = Article.new
        article.user = current_user
        article.channel = @channel
        article.title = t('articles.standard_title', :locale => @channel.defaultLanguage)
        article.content = t('articles.standard_content', :locale => @channel.defaultLanguage)
        article.save

        feedback t('channels.created')
        redirect_to channel_path(@channel)
      else
        feedback t('channels.not_created')
        errors_to_feedback(@channel)
        render action: "new", layout: 'login'
      end
    end
  end

  # PUT /channels/1
  def update
    @channel = Channel.find(params[:id])
    unless has_superadmin_privileges? || Relationship.is_user_admin_of_channel?(current_user, @channel)
      feedback "Access denied!"
      redirect_to :back
    end

    # Make sure that advertising is not set to false while user is not a superadmin
    @channel.advertising = params[:channel][:advertising]
    if !params[:channel][:advertising].nil? && !has_superadmin_privileges?
      @channel.advertising = true
    end

    params[:channel].delete :advertising

    if @channel.update_attributes(params[:channel])
      feedback t('channels.updated')
    else
      feedback t('channels.not_updated')
      errors_to_feedback(@channel)
    end

    redirect_to channels_path
  end

  # DELETE /channels/1
  def destroy
    @channel = Channel.find(params[:id])

    if has_superadmin_privileges? || Relationship.is_user_admin_of_channel?(current_user, @channel)
      @notifications = Notification.find_all_by_channel_id(@channel.id)
      @notifications.each do |n|
        n.destroy
      end

      relationships = Relationship.find_all_by_channel_id(@channel.id)
      relationships.each do |r|
        r.destroy
      end

      articles = Article.find_all_by_channel_id(@channel.id)
      articles.each do |a|
        a.destroy
      end

      @channel.destroy

      feedback t('channels.destroyed')

      set_current_channel nil

      redirect_to channels_path
    else
      feedback t('application.permission_denied')
      redirect_to channels_path
    end
  end

  # GET /channels/unset
  def unset
    set_current_channel nil

    redirect_to channels_path
  end

  # GET /channels/all
  def all
    @channels = Channel.all
  end
end
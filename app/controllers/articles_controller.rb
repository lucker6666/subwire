class ArticlesController < ApplicationController
  # User have to be logged in, choosed an channel and
  # have to be allowed to see that channel
  before_filter :authenticate_user!, :choose_channel!, :check_permissions

  # GET /articles
  def index
    if params[:query].present?
      @articles = Article.search(params[:query],
        load: true,
        page: params[:page],
        per_page: 5,
        order: "created_at DESC",
        conditions: { channel_id: current_channel.id }
      )
    else
      @articles = Article.paginate(
        page: params[:page],
        per_page: 5,
        order: "created_at DESC",
        conditions: { channel_id: current_channel.id }
      )
    end
  end

  # GET /articles/1
  def show
    @article = Article.find(params[:id])

    @notifications = current_user.notification.where(
      channel_id: current_channel.id,
      is_read: false
    )

    # Delete all notifications regarding that article
    unless @notifications.nil?
      @notifications.each do |n|
        n.read! if n.href == article_path(@article)
      end
    end

    # Make sure the users see no deleted notifications after that
    load_notifications

    @notifications = current_user.notifications.find_all
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  def create
    @article = Article.new(params[:article])
    @article.user = current_user
    @article.channel = current_channel

    # Notify all users
    if @article.save
      Notification.notify_all_users({
        notification_type: "new_article",
        provokesUser: @article.user.id,
        subject: @article.title,
        href: article_path(@article)
      }, current_channel, current_user)

      feedback t('articles.created')
      redirect_to article_path(@article)
    else
      feedback t('articles.not_created')
      errors_to_feedback @article
      render action: "new"
    end
  end

  # PUT /articles/1
  def update
    if has_admin_privileges?
      @article = Article.find(params[:id])
    else
      @article = current_user.articles.find(params[:id])
    end

    if @article.update_attributes(params[:article])
      # Notify all users
      Notification.notify_all_users({
        notification_type: "edit_article",
        provokesUser: current_user.id,
        subject: @article.title,
        href: article_path(@article)
      }, current_channel, current_user)

      feedback t('articles.updated')
      redirect_to article_path(@article)
    else
      errors_to_feedback @article
      render action: "edit"
    end
  end

  # DELETE /articles/1
  def destroy
    if has_admin_privileges?
      @article = Article.find(params[:id])
    else
      @article = current_user.articles.find(params[:id])
    end

    # Delete all notifications
    @notifications = current_channel.notifications.where(
      href: article_path(@article)
    )

    @notifications.each { |n| n.destroy }

    # Delete all comments
    @article.commments.each { |c| c.destroy }

    # Delete article
    @article.destroy

    feedback t('articles.destroyed')
    redirect_to articles_url
  end
end

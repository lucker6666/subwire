class ArticlesController < ApplicationController
  # User have to be logged in, choosed an channel and have to be allowed to see that channel
  before_filter :authenticate_user!, :choose_channel!, :check_permissions

  # GET /articles
  def index
    if params[:query].present?
      @articles = Article.search params[:query],load:true,
        page: params[:page],
        per_page: 5,
        order: "created_at DESC",
        conditions: { channel_id: current_channel.id }
    else
      @articles = Article.find_all_by_channel_id_and_page current_channel.id, params[:page]
    end
  end

  # GET /articles/1
  def show
    @article = Article.find(params[:id])

    @notifications = Notification.where(
      user_id: current_user.id,
      channel_id: current_channel.id,
      is_read: false
    )

    # Delete all notifications regarding that article
    unless @notifications.nil?
      @notifications.each do |notification|
        if notification.href == article_path(@article)
          notification.read!
        end
      end
    end

    # Make sure the users see no deleted notifications after that
    load_notifications

    @notifications = Notification.find_all_by_user_id(current_user.id)
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
    @article = Article.find(params[:id])

    if current_user == @article.user || has_admin_privileges?
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
    else
      redirect_to :back
    end
  end

  # DELETE /articles/1
  def destroy
    @article = Article.find(params[:id])

    if current_user == @article.user || has_admin_privileges?
      # Delete all notifications
      @notifications = Notification.where(
        href: article_path(@article),
        channel_id: current_channel.id
      )

      @notifications.each do |n|
        n.destroy
      end

      # Delete all comments
      @comments = Comment.find_all_by_article_id(@article.id)
      @comments.each do |c|
        c.destroy
      end

      @article.destroy

      feedback t('articles.destroyed')
      redirect_to articles_url
    else
      redirect_to :back
    end
  end
end

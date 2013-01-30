class ArticlesController < ApplicationController
  ### Filters
  before_filter :authenticate_user!, :choose_channel, :check_permissions


  ### Methods

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
      @articles = Article.find_all_by_channel_id_and_page(current_channel.id, params[:page])
    end
  end


  # GET /articles/1
  def show
    @article = Article.find(params[:id])

    # Delete all notifications regarding that article
    @notifications = current_user.notifications.where(
      channel_id: current_channel.id,
      is_read: false
    )

    unless @notifications.nil?
      @notifications.each do |n|
        n.read! if n.href == article_path(@article)
      end
    end

    # Make sure the users see no deleted notifications after that
    load_notifications

    # TODO Whats that?
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

    if @article.save
      # Notify all users in that about the new article
      Notification.notify_all_users({
        notification_type: "new_article",
        provokesUser: @article.user.id,
        subject: @article.title,
        href: article_path(@article)
      }, current_channel, current_user)

      # Feedback for the user
      feedback t('articles.created')

      # Redirection to the new article
      redirect_to article_path(@article)
    else
      # Tell the user, that his article couldn't be saved and let he try it again
      feedback t('articles.not_created')
      errors_to_feedback @article
      render action: "new"
    end
  end


  # PUT /articles/1
  def update
    @article = Article.find(params[:id])
    @article = nil if !has_admin_privileges? && !@article.is_editable?

    # No change summary? Try again!
    if params[:change_summary].blank?
      feedback "Change summary cannot be empty"
      render :action => "edit"
    elsif @article.update_attributes(params[:article])
      # Generate comment from the summary
      change_summary_comment = Comment.new
      change_summary_comment.content = params[:change_summary]
      change_summary_comment.user = current_user
      @article.comments << change_summary_comment
      @article.save

      # Notify all users
      Notification.notify_all_users({
        notification_type: "edit_article",
        provokesUser: current_user.id,
        subject: @article.title,
        href: article_path(@article)
      }, current_channel, current_user)

      # Feedback and good bye
      feedback t('articles.updated')
      redirect_to article_path(@article)
    else
      # Couldn't save
      errors_to_feedback @article
      render action: "edit"
    end
  end


  # DELETE /articles/1
  def destroy
    # TODO What if there is no article?
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

  # post /ajax/article/mark_as_important
  def ajax_mark_as_important
    @article = Article.find(params[:id])
    @article.is_important = params[:is_important]
    render :json => {:r => @article.save}
  end
end

class CommentsController < ApplicationController
  ### Filters

  # User have to be logged in, choosed an channel and have to be allowed to see that channel
  before_filter :authenticate_user!, :check_permissions



  ### Methods

  # POST /comments
  def create
    # TODO check if the article is visible for the user to avoid cross-channel-hacks/-spam

    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(params[:comment])
    @comment.user = current_user

    # Notify all users
    if @comment.save
      Notification.notify_all_users({
        notification_type: "new_comment",
        provokesUser: @comment.user.id,
        subject: @article.title,
        href: article_path(@article)
      }, current_channel, current_user)

      feedback t("comments.new_success")
    else
      errors_to_feedback @comment
    end

    redirect_to article_path(@article)
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    # TODO check if the article is visible for the user to avoid cross-channel-hacks/-spam

    # Make sure the user is the author of the comment or user is admin
    if has_admin_privileges?
      @comment = Comment.find(params[:id])
    else
      @comment = current_user.comments.find(params[:id])
    end

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to :back, notice: t("comments.update_success") }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    # Make sure the user is the author of the comment or user is admin
    if has_admin_privileges?
      @comment = Comment.find(params[:id])
    else
      @comment = current_user.comments.find(params[:id])
    end

    @notifications = Notification.find_all_by_href(article_path(@comment.article))
    @notifications.each do |n|
      n.destroy
    end

    @comment.destroy

    feedback t('comments.destroyed')

    redirect_to :back
  end

  def ajax_load_all_comments
    article = Article.find(params[:article_id])
    render :partial => 'shared/comments', :locals => {:comments => article.newest_comments, :article => article }
  end
end

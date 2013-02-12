class CommentsController < ApplicationController
  before_filter :load_channel
  before_filter :load_message
  before_filter :load_comment, only: [:destroy]


  # POST /channels/:id/messages/:id/comments/
  def create
    authorize! :create, Comment

    @comment = @message.comments.build(params[:comment])
    @comment.user = current_user

    # Notify all users
    if @comment.save
      Notification.notify_all_users({
        notification_type: :new_comment,
        provokesUser: @comment.user,
        subject: @message.title,
        href: channel_message_path(@current_channel, @message)
      }, @current_channel, current_user)

      feedback t("comments.new_success")
    else
      errors_to_feedback @comment
    end

    redirect_to channel_message_path(@current_channel, @message)
  end


  # DELETE /channels/:id/messages/:id/comments/:id
  def destroy
    authorize! :destroy, @comment

    message_path = channel_message_path(@current_channel, @message)

    Notification.where(href: message_path).destroy_all
    @comment.destroy

    feedback t('comments.destroyed')
    redirect_to message_path
  end


  # GET /channels/:id/messages/:id/comments/load_all
  def load_all
    render :partial => 'shared/comments', :locals => {
      comments: @message.newest_comments.reverse,
      message: @message
    }
  end


  private

    def load_message
      @message = Message.find(params[:message_id])
      authorize! :read, @message
    end

    def load_comment
      @comment = Comment.find(params[:id])
      authorize! :read, @comment
    end
end

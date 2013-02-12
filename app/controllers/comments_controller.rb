class CommentsController < ApplicationController
  before_filter :load_channel
  before_filter :load_message


  # POST /channels/:id/messages/:id/comments/
  def create
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
end

class MessagesController < ApplicationController
  before_filter :load_channel
  before_filter :load_message, only: [:show, :edit, :update, :destroy, :mark_as_important]


  # GET /channel/:id/messages
  def index
     if params[:query].present?
      @messages = Message.search(params[:query],
        load: true,
        page: params[:page],
        per_page: 10,
        order: "created_at DESC",
        conditions: { channel_id: @current_channel.id }
      )
    else
      @messages = Message.find_all_by_channel_id_and_page(@current_channel.id, params[:page])
    end
  end


  # GET /channel/:id/messages/:id
  def show
    # Delete all notifications regarding that article
    @notifications = current_user.notifications.where(
      channel_id: @current_channel.id,
      is_read: false,
      href: channel_message_path(@current_channel, @message)
    ).each { |n| n.read! }

    # Update the notifications of the user
    load_notifications
  end


  # POST /channel/:id/messages
  def create
    @message = Message.new(params[:message])
    @message.user = current_user
    @message.channel = @current_channel

    if @message.save
      # Notify all users in that about the new message
      Notification.notify_all_users({
        notification_type: :new_message,
        provokesUser: @message.user,
        subject: @message.title,
        href: channel_message_path(@current_channel, @message)
      }, @current_channel, current_user)

      # Feedback for the user
      feedback t('messages.created')

      # Redirection to the new message
      redirect_to channel_messages_path(@current_channel)
    else
      # Tell the user, that his message couldn't be saved and let he try it again
      feedback t('messages.not_created')
      errors_to_feedback @message
      render action: :new
    end
  end


  # PUT /channel/:id/messages/:id
  def update
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
        provokesUser: current_user,
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


  # GET /channel/:id/messages
  def destroy
    channel = @message.channel
    path = channel_message_path(channel, @message)

    @notifications = channel.notifications.where(href: path).destroy_all
    @message.comments.destroy_all
    @message.destroy

    feedback t('articles.destroyed')
    redirect_to channel_url(channel)
  end


  # POST /channels/:id/messages/:id/mark_as_important
  def mark_as_important
    @message.is_important = params[:is_important]
    render :json => {:r => @message.save}
  end



  private

    def load_message
      @message = Message.find(params[:id])
      authorize! :read, @message
    end
end

class MessagesController < ApplicationController
  before_filter :load_channel

  # GET /channel/:id/articles
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

  # POST /channel/:id/articles
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
        href: message_path(@message)
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
end

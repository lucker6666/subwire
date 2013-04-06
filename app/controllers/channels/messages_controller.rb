class Channels::MessagesController < ApplicationController
  before_filter :load_channel
  before_filter :load_message, only: [:show, :edit, :update, :destroy, :mark_as_important]
  before_filter :section


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
    # Set all notifications regarding that message as read
    @notifications = current_user.notifications.where(
      channel_id: @current_channel.id,
      is_read: false,
      href: channel_message_path(@current_channel, @message)
    ).each { |n| n.read! }

    # Update the notifications of the user
    load_notifications

    @in_message = true
  end


  # POST /channel/:id/messages
  def create
    authorize! :create, Message

    @message = Message.new(params[:message])
    @message.user = current_user
    @message.channel = @current_channel

    if @message.save

      if @message.title.nil?
        notifySubject = @message.content[0,75] + '...'
      else
        notifySubject = @message.title
      end

      # Notify all users in that about the new message
      Notification.notify_all_users({
        notification_type: :new_message,
        provokesUser: @message.user,
        subject: notifySubject,
        href: channel_message_path(@current_channel, @message)
      }, @current_channel, current_user)

      # Feedback for the user
      feedback t('messages.created'), :success

      # Redirection to the new message
      redirect_to channel_messages_path(@current_channel)
    else
      # Tell the user, that his message couldn't be saved and let he try it again
      feedback t('messages.not_created'), :error
      errors_to_feedback @message
      render action: :new
    end
  end


  # GET /channel/:id/messages/new
  def new
    @message = Message.new
    authorize! :create, Message
  end


  # GET /channel/:id/messages/:id/edit
  def edit
    authorize! :update, @message
  end


  # PUT /channel/:id/messages/:id
  def update
    authorize! :update, @message

    # No change summary? Try again!
    if params[:change_summary].blank?
      # TODO translate
      feedback "Change summary cannot be empty", :error
      render :action => "edit"
    elsif @message.update_attributes(params[:message])
      # Generate comment from the summary
      change_summary_comment = Comment.new
      change_summary_comment.content = params[:change_summary]
      change_summary_comment.user = current_user
      @message.comments << change_summary_comment
      @message.save

      # Notify all users
      Notification.notify_all_users({
        notification_type: "edit_message",
        provokesUser: current_user,
        subject: @message.title,
        href: channel_message_path(@current_channel, @message)
      }, @current_channel, current_user)

      # Feedback and good bye
      feedback t('messages.updated'), :success
      redirect_to channel_message_path(@current_channel, @message)
    else
      # Couldn't save
      errors_to_feedback @message
      render action: "edit"
    end
  end


  # GET /channel/:id/messages
  def destroy
    authorize! :destroy, @message

    channel = @message.channel
    path = channel_message_path(channel, @message)

    @notifications = channel.notifications.where(href: path).destroy_all
    @message.comments.destroy_all
    @message.destroy

    feedback t('articles.destroyed'), :error
    redirect_to channel_url(channel)
  end


  # POST /channels/:id/messages/:id/mark_as_important
  def mark_as_important
    authorize! :update, @message

    @message.is_important = params[:is_important]
    render :json => {:r => @message.save}
  end



  private

    def load_message
      @message = Message.find(params[:id])
      authorize! :read, @message
    end

    def section
      set_section :discussions
    end
end

class NotificationsController < ApplicationController
  # User have to be logged in and have to be allowed to see that channel
  before_filter :authenticate_user!, :check_permissions

  # GET /notifications.json
  def index
    # Set Activity
    current_user.last_activity = Time.now
    current_user.save

    @notifications = Notification.order("is_read").order("created_at DESC").limit(5).where(
      user_id: current_user.id,
      channel_id: current_channel.id
    )

    respond_to do |format|
      format.json { render json: @notifications, methods: [:message, :avatar_path] }
    end
  end

  # GET /notifications/1
  def show
    if (params[:id])
      notification = current_user.notifications.find(params[:id])
      target = articles_path

      if notification.channel != current_channel
        set_current_channel notification.channel
      end

      target = notification.href
      notification.read!

      redirect_to target
    end
   end

  # DELETE /notifications/1.json
  def destroy
    # Mark all as read
    notifications = current_user.notifications.where(
      channel_id: current_channel.id,
      is_read: false
    )

    notifications.each { |n| n.read! }

    # Return the last 5 Notifications
    @notifications = Notification.order("is_read").order("created_at DESC").limit(5).where(
      user_id: current_user.id,
      channel_id: current_channel.id
    )

    respond_to do |format|
      format.json { render json: @notifications, methods: [:message, :avatar_path] }
    end
  end

  def ajax_load_all_notifications
      render partial: 'shared/navbar/channelSwitcher',
          locals: {:all_channels_notifications => Notification.all_notifications_count(current_user.id)}
  end
end
class Users::NotificationsController < ApplicationController
  before_filter :load_notification, only: [:show, :destroy]


  # GET /notifications.json
  def index
    #@notifications = Notification.order("is_read").order("created_at DESC").limit(5).where(
    #  user_id: current_user.id
    #)
    
    load_notifications

    respond_to do |format|
      format.json do
        render json: @all_notifications, methods: [:message, :avatar_path]
      end
    end
  end


  # GET /notifications/:id
  def show
    @notification.read!
    redirect_to URI.parse(@notification.href).path
  end


  private

    def load_notification
      @notification = Notification.find(params[:id])
      authorize! :read, @notification
    end
end
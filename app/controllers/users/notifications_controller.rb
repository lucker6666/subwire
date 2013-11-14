class Users::NotificationsController < ApplicationController
  before_filter :load_notification, only: [:show, :destroy]


  # GET /notifications.json
  def index
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
  
  def destroy 
    Notification.mark_all_as_read(current_user.id)
    
    load_notifications

    respond_to do |format|
      format.json do
        render json: @all_notifications, methods: [:message, :avatar_path]
      end
    end
  end


  private

    def load_notification
      @notification = Notification.find(params[:id])
      authorize! :read, @notification
    end
end

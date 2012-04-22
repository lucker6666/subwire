class NotificationsController < ApplicationController
  before_filter :authenticate_user!

	# GET /comments/1
  def show
  	if (params[:id])
    	@notification = Notification.find(params[:id])
			target = "/"

    	if @notification && @notification.user == current_user
 				target = @notification.href
    		@notification.destroy
    	end
    end

   	redirect_to target
  end
end
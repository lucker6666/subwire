class NotificationsController < ApplicationController
	before_filter :authenticate_user!

	# GET /notifications.json
	def index
		@notifications = Notification.find_all_by_user_id(current_user.id)

		respond_to do |format|
			#format.html # index.html.erb
			format.json { render json: @notifications }
		end
	end

	# GET /notifications/1
	def show
		if (params[:id])
			notification = Notification.find(params[:id])
			target = "/"

			if notification && notification.user == current_user
				target = notification.href
				notification.destroy
			end

			redirect_to target
		end
	 end
end
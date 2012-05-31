class NotificationsController < ApplicationController
	before_filter :authenticate_user!, :check_permissions

	# GET /notifications.json
	def index
		@notifications = Notification.where(
			:user_id => current_user.id,
			:instance_id => current_instance.id
		)

		respond_to do |format|
			format.json { render json: @notifications }
		end
	end

	# GET /notifications/1
	def show
		if (params[:id])
			notification = Notification.find(params[:id])
			target = "/"

			if notification && notification.user == current_user &&
				notification.instance == current_instance

				target = notification.href
				notification.destroy
			end

			redirect_to target
		end
	 end
end
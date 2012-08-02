class NotificationsController < ApplicationController
	# User have to be logged in and have to be allowed to see that instance
	before_filter :authenticate_user!, :check_permissions

	# GET /notifications.json
	def index
		#Set Activity
		current_user.last_activity = Time.now
		current_user.save

		@notifications = Notification.order("is_read").order("created_at DESC").limit(5).where(
			:user_id => current_user.id,
			:instance_id => current_instance.id
		)

		respond_to do |format|
			format.json { render json: @notifications, :methods => [:message, :avatar_path] }
		end
	end

	# GET /notifications/1
	def show
		if (params[:id])
			notification = Notification.find(params[:id])
			target = :back

			if notification && notification.user == current_user &&
				notification.instance == current_instance

				target = notification.href
				notification.read!
			end

			redirect_to target
		end
	 end
end
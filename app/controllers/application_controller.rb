# Controller base class
class ApplicationController < ActionController::Base
	# Enable CSRF protection
	protect_from_forgery

	# We need all helpers, all the time
	helper :all


	private

	# ================================================================================================
	# Finds the User with the ID stored in the session with the key
	# :current_user_id This is a common way to handle user login in
	# a Rails application; logging in sets the session value and
	# logging out removes it.

	def current_user
		@_current_user ||= session[:user_id] && User.find_by_id(session[:user_id])
	end


	# ================================================================================================
	# Checks if the current user is signed in

	def user_signed_in?
		current_user.present?
	end

	helper_method :user_signed_in?


	# ================================================================================================
	# Ensures that user is logged in

	def require_login
		unless user_signed_in?
			notify "You have to login first."
			redirect_to login_path
		end
	end


	# ================================================================================================
	# Send a message to the user over the notification system. Will use jGrowl in frontend

	def notify(msg)
	  # Case 1: null or empty string
	  if flash[:messages].nil? || flash[:messages].to_s.strip.length == 0
	    flash[:messages] = msg
	  # Case 2: array
	  elsif flash[:messages].kind_of?(Array)
	    flash[:messages].push(msg)
	  # Case 3: contains a string
	  else
	    str = flash[:messages]
	    flash[:messages] = [str, msg]
	  end
	end


	# ================================================================================================
	# Convert all errors of a model to notifications

	def errors_to_notifications(model)
	  model.errors.each do |error, message|
	    notify message
	  end
	end
end
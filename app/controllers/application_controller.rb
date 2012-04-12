# Controller base class
class ApplicationController < ActionController::Base
	# Enable CSRF protection
	protect_from_forgery

	# We need all helpers, all the time
	helper :all


	private


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
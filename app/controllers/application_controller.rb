# Controller base class
class ApplicationController < ActionController::Base
	# Enable CSRF protection
	protect_from_forgery

	# We need all helpers, all the time
	helper :all

	layout :layout_by_resource


  protected

  def layout_by_resource
    if devise_controller?
      "login"
    else
      "application"
    end
  end


	private


	# ================================================================================================
	# Send a message to the user over the notification system. Will use jGrowl in frontend

	def notify(msg)
	  # Case 1: null or empty string
	  if flash[:alert].nil? || flash[:alert].to_s.strip.length == 0
	    flash[:alert] = msg
	  # Case 2: array
	  elsif flash[:alert].kind_of?(Array)
	    flash[:alert].push(msg)
	  # Case 3: contains a string
	  else
	    str = flash[:alert]
	    flash[:alert] = [str, msg]
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
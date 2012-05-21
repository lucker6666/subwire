# Controller base class
class ApplicationController < ActionController::Base
	# Enable CSRF protection
	protect_from_forgery
	before_filter :set_locale

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


  def check_admin
  	if current_user.is_admin?
  		return true
  	else
  		notify t :application.no_admin
  		redirect_to :back
  	end
  end

  def check_superadmin
  	if current_user.is_admin?
  		return true
  	else
  		notify t :application.no_superadmin
  		redirect_to :back
  	end
  end



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

	private

	def set_locale
	  I18n.locale = params[:locale] || I18n.default_locale
	end

	def default_url_options(options=[])
	  { :locale => I18n.locale }
	end

	def locale_path(locale)
		locale_regexp = %r{/(en|de)/?}
		if request.env['PATH_INFO'] =~ locale_regexp
			"#{request.env['PATH_INFO']}".
			gsub(locale_regexp, "/#{locale}/")
		else
			"/#{locale}#{request.env['PATH_INFO']}"
		end
	end
	helper_method :locale_path
end
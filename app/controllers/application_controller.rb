# Controller base class
class ApplicationController < ActionController::Base
	# Enable CSRF protection
	protect_from_forgery

	# set_locale: Determines the language of the user
	# refresh_config: Reloads the current instance config from database
	before_filter :set_locale, :refresh_config, :globals, :set_timezone

	# We need all helpers, all the time
	helper :all

	# Changes layout depending on controller
	layout :layout_by_resource


	protected

		# Set some global variables, which are required in the views of each request
		def globals
			if current_instance
				@users = Relationship.find_all_users_by_instance(current_instance)
				@links = Link.where(:instance_id => current_instance.id)
			end

			return true
		end

		# Changes layout depending on controller
		def layout_by_resource
			if devise_controller?
				"login"
			else
				"application"
			end
		end

		# Sends a message to the user over the feedback system. Will use jGrowl in frontend.
		def feedback(msg)
			# Case 1: nil or empty string or empty array
			if flash[:alert].nil? || flash[:alert].to_s.strip.length == 0
				flash[:alert] = [msg]
				return
			# Case 2: array
			elsif flash[:alert].kind_of?(Array)
				flash[:alert].push(msg)
			# Case 3: contains a string
			else
				str = flash[:alert]
				flash[:alert] = [str, msg]
			end
		end

		# Converts all errors of a model to feedback messages
		def errors_to_feedback(model)
			model.errors.each do |error, message|
				feedback message
			end
		end


		# Filters:

		# Reloads the current instance config from database
		def refresh_config
			if current_instance
				set_current_instance Instance.find(current_instance.id)
			end
		end

		# Filter that returns true if the user has admin privileges. That's if the user is a superadmin
		#  (is_admin flag of user) or the user is admin for current_instance.
		# Otherwise it redirects back and notify the user.
		def restricted_to_admin
			unless has_admin_privileges?
				feedback t :application.no_admin
				redirect_to :back
			end
		end

		# Filter that returns true if the current user is a superadmin (is_admin flag of user).
		# Otherwise it redirects back and notify the user.
		def restricted_to_superadmin
			unless has_superadmin_privileges?
				feedback t :application.no_superadmin
				redirect_to :back
			end
		end

		# Filter which determines the language of the current user
		def set_locale
			if current_user
		  		I18n.locale = current_user.lang || I18n.default_locale
		  	else
				I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
		  	end
		end

		def set_timezone
			if current_user
				Time.zone = current_user.timezone || 'Central Time (US & Canada)'
			else
				Time.zone =  'Central Time (US & Canada)'
			end
			
		end

		# Filter which forces the user to choose an instance
		def choose_instance!
			unless current_instance
				redirect_to instances_path
			end
		end

		# Checks wether the current user is allowed to see the requested instance. If not,
		# the user will be redirected to the instance overview.
		def check_permissions
			# Logged in? If not, redirect to login mask
			if current_user
				# Is there a instance choosen? If not, redirect to the instance overview
				if current_instance
					# If the user is a superadmin everything is ok
					unless current_user.is_admin?
						# Get the relationship between current_user and current_instance)
						rs = current_rs

						# If there is no relationship, the user is not allowed to see that instance.
						# So redirect to instances overview. Otherwise everything is ok
						unless rs
							feedback t :application.no_permission_for_instance
							redirect_to instances_path
						end
					end
				else
					redirect_to instances_path
				end
			else
				redirect_to "/"
			end
		end
end

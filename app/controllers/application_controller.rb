# Controller base class
class ApplicationController < ActionController::Base
	# Enable CSRF protection
	protect_from_forgery

	# set_locale: Determines the language of the user
	# refresh_config: Reloads the current instance config from database
	before_filter :finish_invitation, :set_locale, :refresh_config, :globals, :set_timezone

	# We need all helpers, all the time
	helper :all

	# Changes layout depending on controller
	layout :layout_by_resource


	protected

		# Set some global variables, which are required in the views of each request.
		# Additionally, set the session[:instance] field to the instance, which is display currently
		# Thats required to handle manual URL changes thru the user, which may cause an instance
		# switch. However, thats somewhat tricky und unfancy right now. If someone has a better
		# idea, refactor this, pls.
		def globals
			# If user it not logged in, this is irrelevant
			if current_user
				# And if the user is a superadmin thats irrelevant too
				unless current_user.is_admin?
					if params[:id] && !["instances", "users", "comments"].include?(params[:controller])
						resource = params[:controller].capitalize.singularize.constantize
						instance_backup = session[:instance]
						session[:instance] = resource.find(params[:id]).instance

						# session[:instance] should never be null after that
						if session[:instance].nil?
							session[:instance] = instance_backup
						end
					end
				end

				users = User.find :all, :conditions => ["created_at < ? ", 30.days.ago]
				users.each { |u| u.destroy }

				if current_instance
					@sidebar_users = Relationship.find_all_users_by_instance(current_instance).sort_by(&:name)
					@sidebar_links = Link.where(:instance_id => current_instance.id)
					@subwireTitle = current_instance.name

					load_notifications
				else
					@subwireTitle = Subwire::Application.config.subwire_title
				end
			end

			return true
		end

		# Call that everytime you change notifications
		def load_notifications
			if current_user && current_instance
				@all_notifications = Notification.find_all_relevant(current_instance, current_user)
				@unread_notification_count = @all_notifications.find_all { |n| n.is_read == false }.length
			end
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

		def finish_invitation
			if current_user && current_user.invitation_pending
				redirect_to "/users/finish"
			end
		end

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
			elsif request.env['HTTP_ACCEPT_LANGUAGE'] != nil
				I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
			else
				I18n.locale = I18n.default_locale
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
							feedback t 'application.no_permission_for_instance'
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

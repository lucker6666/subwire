# Controller base class
class ApplicationController < ActionController::Base
	# Enable CSRF protection
	protect_from_forgery
	before_filter :set_locale, :refresh_config

	# We need all helpers, all the time
	helper :all

	layout :layout_by_resource

	def current_instance
		session[:instance]
	end


	protected

	def set_current_instance(instance)
		session[:instance] = instance
	end

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
		elsif is_admin_of_instance?
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

	def notify_all_users(data)
		Relationship.find_all_users_by_instance(current_instance).each do |user|
			unless user == current_user
				notification = Notification.new({
					:notification_type => data[:notification_type],
					:message => data[:message],
					:href => data[:href],
					:is_read => false,
					:user => user,
					:instance => current_instance
				})

				notification.save
			end
		end
	end




	private

	def refresh_config
		if current_instance
			set_current_instance Instance.find(current_instance.id)
		end
	end

	def check_permissions
		if current_user
			if current_instance
				unless current_user.is_admin?
					relationships = Relationship.where(
						:user_id => current_user.id,
						:instance_id => current_instance.id)

					unless relationships.any?
						notify t :application.no_permission_for_instance

						if relationships.length > 1
							redirect_to instances_path
						else
							redirect_to destroy_user_session_path, :method => :delete
						end
					end
				end
			else
				redirect_to instances_path
			end
		end
	end

	def set_locale
		if current_user
	  		I18n.locale = current_user.lang || I18n.default_locale
	  	else
			I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
	  	end
	end

	def choose_instance!
		if not current_instance
			redirect_to instances_path
		end
	end
end

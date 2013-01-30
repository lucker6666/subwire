# Controller base class
class ApplicationController < ActionController::Base
  ## Enable CSRF protection
  protect_from_forgery

  ## We need all helpers, all the time
  helper :all

  ## Change layout depending on controller
  # FIXME just the login page has another layout, move that to the repective controller
  layout :layout_by_resource


  ### Filters

  # finish_invitation:    Completes an open invitation
  # set_locale:           Determines the language of the user
  # refresh_config:       Reloads the current channel config from database
  # globals:              Set some global variables and actions which have
  #                       to be done on each request
  # set_timezone:         Determines the current timezone
  before_filter :finish_invitation, :set_locale, :refresh_config, :globals, :set_timezone


  ### Methods

  protected
    # For debugging purposes
    def show_actual_url
      p request.url
    end

    def show_actual_body
      p response.body
    end


    # Set some global variables, which are required in the views of each request.
    # Additionally, set the session[:channel] field to the channel, which is display currently
    # Thats required to handle manual URL changes thru the user, which may cause an channel
    # switch. However, thats somewhat tricky und unfancy right now. If someone has a better
    # idea, refactor this, pls.
    def globals
      # If user it not logged in, this is irrelevant
      if current_user
        # And if the user is a superadmin thats irrelevant too
        unless current_user.is_admin?
          # Check if a id is given - channels, users and comments controller are irrelevant for that
          if params[:id] && !["channels", "users", "comments"].include?(params[:controller])
            # Which resource is requested? ("Link", "Notification", ...)
            resource = params[:controller].capitalize.singularize.constantize

            # Save the current channel for the case, that there is no other channel to display.
            channel_backup = session[:channel]

            # Find the instance of the requests resource by the id provided via GET param. And get
            # the channel which is associated with that instance.
            session[:channel] = resource.find(params[:id]).channel

            # Now it may be, that there is no channel to display, so the saved channel will be set
            # as the current channel. After that, session[:channel] shouldn't be nil
            if session[:channel].nil?
              session[:channel] = channel_backup
            end
          end
        end

        # Set last ctivity
        current_user.last_activity = Time.now
        current_user.save

        # Delete all Users, which have been invited before 30 days and the invitation is still
        # pendig.
        users = User.destroy_all(["created_at < ? and invitation_pending = 1", 30.days.ago])

        # Delete all availabilities, which are older then 1 day.
        availabilities = Availability.destroy_all(["date < ?", 1.day.ago])

        # Some global variables
        if current_channel
          @sidebar_users = Relationship.find_all_users_by_channel(current_channel).sort_by(&:name)
          @sidebar_links = Link.find_all_by_channel_id(current_channel.id)
          @subwireTitle = current_channel.name

          load_notifications
        else
          @subwireTitle = Subwire::Application.config.subwire_title
        end
      end

      # Return true to make sure, that the filter chain proceeds after that one
      true
    end


    # Call that everytime you change notifications
    def load_notifications
      if current_user && current_channel
        @all_notifications = Notification.find_all_relevant(current_channel, current_user)
        @unread_notification_count = @all_notifications.where(:is_read => false).count
        @all_channels_notifications = Notification.all_notifications_count(current_user.id)
      end
    end


    # Changes layout depending on controller
    def layout_by_resource
      return devise_controller? ? 'login' : 'application'
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
      model.errors.each { |error, message| feedback message }
    end


    # Finishes a unfinished invitation
    def finish_invitation
      if current_user && current_user.invitation_pending
        redirect_to "/users/finish"
      end
    end


    # Reloads the current channel config from database
    def refresh_config
      if current_channel
        set_current_channel Channel.find(current_channel.id)
      end
    end


    # Filter that returns true if the user has admin privileges.
    # That's if the user is a superadmin (is_admin flag of user)
    # or the user is admin for current_channel.
    # Otherwise it redirects back and notify the user.
    def restricted_to_admin
      unless has_admin_privileges?
        feedback t :application.no_admin
        redirect_to :back
      end
    end


    # Filter that returns true if the current user is
    # a superadmin (is_admin flag of user).
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


    # Fitler which sets the timezone
    def set_timezone
      if current_user
        Time.zone = current_user.timezone || 'Central Time (US & Canada)'
      else
        Time.zone =  'Central Time (US & Canada)'
      end
    end


    # Filter which ensures, that a channel is chosen
    def choose_channel
      unless current_channel
        set_current_channel Relationship.find_all_by_user_id(current_user.id).first.channel
      end
    end


    # Checks wether the current user is allowed to see the requested channel. If not,
    # the user will be redirected to the channel overview.
    def check_permissions
      # Logged in? If not, redirect to login mask
      if current_user
        choose_channel # Just to be sure, that a channel is chosen

        # If the user is a superadmin everything is ok
        unless current_user.is_admin?
          # If there is no relationship, the user is not allowed to see that channel.
          # So redirect to channels overview. Otherwise everything is ok
          unless current_rs
            feedback t 'application.no_permission_for_channel'
            redirect_to articles_path
          end
        end
      else
        redirect_to "/"
      end
    end
end

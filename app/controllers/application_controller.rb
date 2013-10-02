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
  before_filter :log_in!,
                :finish_invitation,
                :set_locale,
                :set_timezone,
                :set_version,
                :cleanup,
                :load_channel,
                :update_last_activity,
                :load_notifications


  # Handle a CanCan AccessDenied Exception
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to channels_path, alert: {msg: t('errors.access_denied'), type: :error}
  end


  ### Methods

  def after_sign_in_path_for(resource)
    channels_path
  end



  protected
    # For debugging purposes
    def show_actual_url
      p request.url
    end

    def show_actual_body
      p response.body
    end


    def update_last_activity
      # If user it not logged in, this is irrelevant
      if current_user
        # Set last ctivity
        current_user.last_activity = Time.now
        current_user.save!
      end
    end

    def log_in!
      unless params[:controller] == 'home' || devise_controller? || current_user
        redirect_to "/"
      end
    end


    def cleanup
      # Delete all Users, which have been invited before 30 days and the invitation is still pendig.
      users = User.destroy_all(["created_at < ? and invitation_pending = 1", 30.days.ago])

      # Delete all availabilities, which are older then 1 day.
      availabilities = Availability.destroy_all(["date < ?", 1.day.ago])
    end


    # Call that everytime you change notifications
    def load_notifications
      if current_user
        @all_notifications = Notification.order("is_read").order("created_at DESC").limit(5).where(user_id: current_user.id)
        @all_channels_notifications = @all_notifications.count

        if @all_notifications.count > 0
          @unread_notification_count = @all_notifications.where(is_read: false).count
        else
          @unread_notification_count = 0
        end
      end
    end


    # Changes layout depending on controller
    def layout_by_resource
      return devise_controller? ? 'login' : 'application'
    end


    # Sends a message to the user over the feedback system. Will use HubSpot Messenger in frontend.
    def feedback(msg, type = :info)
      msg = {msg: msg, type: type}

      # Case 1: nil
      if flash[:alert].nil?
        flash[:alert] = [msg]

      # Case 2: array
      elsif flash[:alert].kind_of?(Array)
        flash[:alert].push(msg)

      # Case 3: contains a string
      else
        str = flash[:alert]
        flash[:alert] = [{msg: str, type: :info}, msg]
      end
    end


    # Converts all errors of a model to feedback messages
    def errors_to_feedback(model)
      model.errors.each { |error, message| feedback(message, :error) }
    end


    # Finishes a unfinished invitation
    def finish_invitation
      if current_user && current_user.invitation_pending
        redirect_to "/users/finish"
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

    # Subwires current version
    def set_version
      @subwire_version = '3.1.0 (Northstar)'
    end

    def load_channels
      @channels = Channel.find(
        :all,
        joins: :relationships,
        conditions: { "relationships.user_id" => current_user.id }
      )
    end

    def load_channel
      if params[:channel_id] || (params[:id] && params[:controller] == 'channels')
        channel_id = params[:channel_id] || params[:id]

        channel = Channel.find_by_id_or_permalink(channel_id)

        unless channel
          feedback t('not_found.project', id: channel_id), :error
          redirect_to channels_path
        end

        set_channel channel
        authorize! :read, current_channel


        @sidebar_users = Relationship.find_all_users_by_channel(current_channel).sort_by(&:name)
        @sidebar_links = Link.find_all_by_channel_id(current_channel.id)
        @subwireTitle = current_channel.name
      end
    end

    def set_section(section)
      @active_section = section
    end

    def set_channel(channel)
      @current_channel = channel
    end

    def current_channel
      @current_channel
    end

    def create_wiki_home
      wiki = Wiki.new
      wiki.user = current_user
      wiki.channel = current_channel
      wiki.is_home = true
      wiki.title = t('wiki.default_page.title')
      wiki.content = t('wiki.default_page.content')
      wiki.save!
      wiki
    end



  private

    def current_ability
      @current_ability ||= Ability.new(current_user, current_channel)
    end

    def handle_cancan_error(exception)
      if request.xhr?
        head :forbidden
      else
        flash[:error] = exception.message
        redirect_to root_url
      end
    end
end

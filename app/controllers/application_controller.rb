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
                :cleanup,
                :load_channel,
                :update_last_activity


  ### Methods

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
        current_user.save
      end
    end

    def log_in!
      unless devise_controller?
        #redirect_to "/"
      end
    end


    def cleanup
      # Delete all Users, which have been invited before 30 days and the invitation is still pendig.
      users = User.destroy_all(["created_at < ? and invitation_pending = 1", 30.days.ago])

      # Delete all availabilities, which are older then 1 day.
      availabilities = Availability.destroy_all(["date < ?", 1.day.ago])
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

    def load_channels
      @channels = Channel.find(
        :all,
        :joins => :relationships,
        :conditions => { "relationships.user_id" => current_user.id }
      )
    end

    def load_channel
      if channel_id = params[:channel_id] || params[:id]
        unless @current_channel = Channel.find_by_id_or_permalink(channel_id)
          feedback t('not_found.project', :id => channel_id)
          redirect_to channels_path
        end

        authorize! :read, @current_channel

        @sidebar_users = Relationship.find_all_users_by_channel(@current_channel).sort_by(&:name)
        @sidebar_links = Link.find_all_by_channel_id(@current_channel.id)
        @subwireTitle = @current_channel.name
      end
    end



  private

    def current_ability
      @current_ability ||= Ability.new(current_user, @current_channel)
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

module Subwire
  class Application < Rails::Application
    ## Title of the application
    #config.subwire_title = "subwire"

    ## Timezone
    #config.time_zone = 'Berlin'

    ##Elasticsearch active?
    #config.elasticsearch = false

    ## Default encoding
    #config.encoding = "utf-8"

    ## Activates GoogleAnalytics integration
    #config.ga = true
    ## Your GoogleAnalytics Key
    #config.ga_key = ""
    ## The Domain (e.g. "subwire.net")
    #config.ga_domain = ""

    ## Error mails
    #config.middleware.use ExceptionNotifier,
    #  :email_prefix => "[Error] ",
    #  :sender_address => %{"Subwire" <no-reply@subwire.net>},
    #  :exception_recipients => %w{info@example.com}

    ## Secret token. Change this in production!
    #config.secret_token = '912ec803b2912ec803b2ce49e4a541068d495ab570ce49e4a541068d495ab570'

    ## Session store key
    #config.session_store :cookie_store, key: '_Subwire_session'

    ## Set this to your applications host
    #config.action_mailer.default_url_options = { host: 'localhost:3000' }
  end
end

## Mail setup
# Devise.setup do |config|
#   config.mailer_sender = "noreply@subwire.net"
# end

# ActionMailer::Base.smtp_settings = {
#   :address              => "localhost",
#   :port                 => 25,
#   :domain               => "localhost",
#   :user_name            => "root",
#   :password             => "root",
#   :authentication       => "plain",
#   :enable_starttls_auto => false,
#   :tls                   => false
# }
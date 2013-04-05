module Subwire
  class Application < Rails::Application
    ## Title of the application
    config.subwire_title = "subwire"

    ## Timezone
    config.time_zone = 'Berlin'

    ## Enable ElasticSearch?
    config.elasticsearch = false

    ## Default encoding
    config.encoding = "utf-8"

    ## Activates GoogleAnalytics integration
    config.ga = false

    ## Your GoogleAnalytics Key
    #config.ga_key = ""

    ## The Domain (e.g. "subwire.net")
    #config.ga_domain = ""

    ## Error mails
    # config.middleware.use ExceptionNotifier,
    #  :email_prefix => "[Error] ",
    #  :sender_address => %{"Subwire" <no-reply@subwire.net>},
    #  :exception_recipients => %w{info@example.com}

    ## Secret token. Change this in production!
    config.secret_token = '912ec803b2912ec803b2ce49e4a541068d495ab570ce49e4a541068d495ab570'

    ## Facebook App Key and Secreit for oauth login
    ENV['FACEBOOK_KEY'] = 'xxxxxxx'
    ENV['FACEBOOK_SECRET'] = 'xxxxxx'

    ## Session store key
    config.session_store :cookie_store, key: '_subwire_session'

    ## Set this to your applications host
    config.action_mailer.default_url_options = { host: 'localhost:3000' }

    ## Background images for login page
    config.backgrounds = [
      {
        file: '1.jpg',
        artist: 'phortx',
        link: 'http://www.flickr.com/photos/onemice/6868663783/in/photostream'
      },
      {
        file: '2.jpg',
        artist: 'paolofefe',
        link: 'http://www.flickr.com/photos/paolofefe/3649759801/sizes/l/in/photostream/'
      },
      {
        file: '3.jpg',
        artist: 'a4gpa',
        link: 'http://commons.wikimedia.org/wiki/File:Autumn_mountain_trail.jpg'
      },
      {
        file: '4.jpg',
        artist: 'Kiatisakj',
        link: 'http://commons.wikimedia.org/wiki/File:3d-wallpaper-widescreen-3.jpg'
      },
      {
        file: '5.jpg',
        artist: 'Nitot',
        link: 'http://commons.wikimedia.org/wiki/File:Eiffel_tower_at_dawn_horizontal.jpg'
      },
      {
        file: '6.jpg',
        artist: 'tajai',
        link: 'http://www.flickr.com/photos/49503037845@N01/390601'
      }
    ]
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

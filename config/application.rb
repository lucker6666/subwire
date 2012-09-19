####################################################################################################
## DON'T CHANGE THIS FILE !!!
## Use config/initializers/config.example.rb instead!
## (Copy or rename to config/initializers/config.rb)
####################################################################################################

require File.expand_path('../boot', __FILE__)
require 'rails/all'

if defined?(Bundler)
	## If you precompile assets before deploying to production, use this line
	Bundler.require(*Rails.groups(:assets => %w(development test)))

	## If you want your assets lazily compiled in production, use this line
	# Bundler.require(:default, :assets, Rails.env)
end

module Subwire
	class Application < Rails::Application
		## Title of the application
		config.subwire_title = "subwire"

		## Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
		## Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
		## config.time_zone = 'Central Time (US & Canada)'
		config.time_zone = 'Berlin'

		## The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
		## config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
		config.i18n.default_locale = :en

		## Configure the default encoding used in templates for Ruby 1.9.
		config.encoding = "utf-8"

		## Configure sensitive parameters which will be filtered from the log file.
		config.filter_parameters += [:password, :content]

		## Enforce whitelist mode for mass assignment.
		## This will create an empty whitelist of attributes available for mass-assignment for all models
		## in your app. As such, your models will need to explicitly whitelist or blacklist accessible
		## parameters by using an attr_accessible or attr_protected declaration.
		config.active_record.whitelist_attributes = true

		## Enable the asset pipeline
		config.assets.enabled = true

		## Version of your assets, change this if you want to expire all your assets
		config.assets.version = '1.0'

		## Activates GoogleAnalytics integration
		config.ga = false

		## Your GoogleAnalytics Key
		#config.ga_key = ""

		## The Domain (e.g. "subwire.net")
		#config.ga_domain = ""

		## Disable view_specs and helper_specs generators
		config.generators do |g|
			g.view_specs false
			g.helper_specs false
		end

		## Partially load application for faster asset precompilition
		config.assets.initialize_on_precompile = false

		## ErrorMails
		#config.middleware.use ExceptionNotifier,
		#	:email_prefix => "[Error] ",
		#	:sender_address => %{"Subwire" <no-reply@subwire.net>},
		#	:exception_recipients => %w{info@example.com}

		## Secret token
		config.secret_token = '912ec803b2912ec803b2ce49e4a541068d495ab570ce49e4a541068d495ab570'

		## Session store key
		config.session_store :cookie_store, key: '_Subwire_session'

		## Application host
		config.action_mailer.default_url_options = { :host => 'localhost:3000' }
	end
end

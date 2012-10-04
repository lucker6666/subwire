####################################################################################################
## DON'T CHANGE THIS FILE !!!
## Use config/initializers/config.example.rb instead!
## (Copy or rename to config/initializers/config.rb)
####################################################################################################

require File.expand_path('../boot', __FILE__)
require 'rails/all'

if defined?(Bundler)
  ## If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(assets: %w(development test)))

  ## If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Subwire
  class Application < Rails::Application
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

    ## Disable view_specs and helper_specs generators
    config.generators do |g|
      g.view_specs false
      g.helper_specs false
    end

    ## Partially load application for faster asset precompilition
    config.assets.initialize_on_precompile = false
  end
end

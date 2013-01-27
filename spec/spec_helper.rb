# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

# simplecov configuration
require 'simplecov'
SimpleCov.start do
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Helpers", "app/helpers"
  add_group "Lib", "lib"

  add_filter "/spec/"
end

# Booting rails, rspec, factory_girl, ...
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'shoulda-matchers'
require 'factory_girl'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Configure rspec
RSpec.configure do |config|
  # Include helpers
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  config.include(Subwire::RSpecHelper)

  # Fixture path
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Run each example within a transaction
  config.use_transactional_fixtures = true

  # Run specs in random order to surface order dependencies
  config.order = "random"
end

#OmniAuth.config.test_mode = true
#OmniAuth.config.mock_auth[:facebook] = {
#                        :uid => '12345',
#                        :provider => 'facebook',
#                        :user_info => {'name' => 'Cookie', 'email' => 'fb@example.com'},
#                        :credentials => {'token' => 'token'}
#                        }

def log_in_user(user = "user1_with_channel")
  rel = FactoryGirl.create(user.to_sym)
  sign_in rel.user
  set_current_channel rel.channel
  rel
end

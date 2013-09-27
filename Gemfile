source 'http://rubygems.org'

# Base
gem 'rails', '~>3.2.11'
gem 'bcrypt-ruby', '~> 3.0.1'
gem 'paperclip'
gem 'rmagick'
gem 'exception_notification'
gem 'haml'
gem 'has_permalink'

# Databases
gem 'sqlite3', group: :sqlite
gem 'mysql2', group: :mysql


# Authorization and Authentication
gem 'devise', '~> 2.2.2'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-openid'
gem 'omniauth-google-apps'
gem 'cancan'

# Assets
group :assets do
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '~> 1.3.0'
  gem 'sass-rails',   '~> 3.2.6'
  gem 'turbo-sprockets-rails3'
  gem 'rails-backbone'
end

# Frontend
gem 'twitter-bootstrap-rails'
gem 'jquery-rails'
gem 'ckeditor'
gem 'will_paginate'
gem 'will_paginate_twitter_bootstrap'
gem 'rails_autolink'
gem 'rmagick'
gem 'html_truncator'
gem 'less-rails'
gem 'therubyracer', '~> 0.10.0'

# Search engine
gem 'tire'

# Testing
group :test do
  gem 'email_spec'
  gem 'cucumber-rails', require: false
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'brakeman'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'fuubar'
  gem 'simplecov'
  gem 'factory_girl_rails'
  gem 'libnotify', :require => false
  gem 'growl', :require => false
  gem 'guard-rspec'
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
end

group :development do
  gem 'pre-commit'
  gem 'binding_of_caller'
  gem 'awesome_print'
  gem 'rack-livereload'
  gem 'guard-livereload'
  gem 'better_errors'
  gem 'plymouth', require: false
end

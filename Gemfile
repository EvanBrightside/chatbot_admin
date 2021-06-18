source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3', '>= 6.1.3.2'
# Use postgresql as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
# Background jobs
gem 'sidekiq'
# Scheduled jobs
gem 'whenever', require: false

gem 'daemons'
gem 'uglifier', '>= 1.3.0'

gem 'dip', require: false

## Admin UI
gem 'adminos', github: 'EvanBrightside/adminos', branch: 'update/rails-6'

## Messengers
gem 'telegram-bot'
gem 'vkontakte_api'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry'
  gem 'shoulda-matchers'
  gem 'bundler-audit'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'minitest'
  gem 'rspec-rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Guard automates bundling, spec checking and other things
  gem 'guard'
  gem 'guard-livereload', '~> 2.5', require: false

  ## Deployment
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano3-puma'
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano-systemd-multiservice', '~> 0.1.0.beta6', require: false

  ## Development Mailer
  gem 'letter_opener'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

group :lint do
  gem 'rubocop'
end

gem 'role_model'
gem 'active_storage_validations'
gem 'image_processing'
gem 'capistrano-db-tasks', require: false
gem 'sanitize'
gem 'carrierwave'
gem 'mini_magick'
gem 'scoped_search'
gem 'pg_search'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-vkontakte'
gem 'omniauth-github'
gem 'axlsx', github: 'randym/axlsx'
gem 'spreadsheet_architect'
gem 'mobility'
gem 'mobility-ransack', '~> 0.2.2'
gem 'devise-i18n'
gem 'kaminari-i18n'
gem 'rails-i18n'
gem 'tolk'
gem 'inline_svg'
gem 'dotenv-rails'
gem 'simple_form'
gem 'enumerize'
gem 'autoprefixer-rails', '8.6.5'
gem 'select2-rails'
gem 'bootstrap-datepicker-rails'
gem 'jquery-simplecolorpicker-rails'
gem 'autosize-rails'
gem 'slim-rails'
gem 'russian'
gem 'sentry-ruby'
gem 'chartkick'
gem 'colorize'

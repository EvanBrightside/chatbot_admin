require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require File.expand_path("../lib/extensions/scoped_search_definition_ruby_3_fix.rb", __dir__)

module ChatbotAdmin
  class Application < Rails::Application
    config.i18n.default_locale = :ru
    config.time_zone = 'Moscow'
    config.i18n.available_locales = [:ru]
    config.generators { |g| g.test_framework :rspec }
    # config.action_mailer.default_url_options = { host: 'molinos.dev' }
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.to_prepare do
      Devise::SessionsController.layout 'admin'
      Devise::RegistrationsController.layout proc { |controller| user_signed_in? ? 'application' : 'admin' }
      Devise::ConfirmationsController.layout 'admin'
      Devise::UnlocksController.layout 'admin'
      Devise::PasswordsController.layout 'admin'
    end
    config.load_defaults 6.0
    config.active_job.queue_adapter = :sidekiq

    ActiveStorage::Engine.config.active_storage.content_types_to_serve_as_binary.delete('image/svg+xml')
  end
end

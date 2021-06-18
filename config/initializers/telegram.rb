# require 'telegram_client_patch'

Rails.application.configure do
  config.to_prepare do
    if  %w[TG_BOT_TOKEN TG_BOT_NAME].all? { |el| ENV[el].present? }
      Rails.configuration.telegram_client = Telegram::Bot::Client.new(ENV['TG_BOT_TOKEN'], ENV['TG_BOT_NAME'])
    else
      Rails.configuration.telegram_client = nil
    end
  end
end

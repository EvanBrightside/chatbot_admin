class TgAdapterController < Telegram::Bot::UpdatesController
  if Rails.configuration.telegram_client
    def start!(*)
      user_data = user_data(chat)
      # Customer.save_customer(user_data)
      msg = dialog.respond('/start', user_data)
      send_message.(msg, chat['id'])
    end

    def message(message)
      user_data = user_data(message['from'])
      msg = dialog.respond(message['text'], user_data)
      send_message.(msg, message['from']['id'])
    end

    private

    def user_data(data)
      [
        id: data['id'],
        first_name: data['first_name'],
        last_name: data['last_name'],
        adapter: 'tg'
      ]
    end

    def bot
      @bot ||= Rails.configuration.telegram_client
    end

    def dialog
      DialogService.new(:tg, chat['id'])
    end

    def send_message
      @send_message ||= SendTelegramMessage.new
    end
  end
end

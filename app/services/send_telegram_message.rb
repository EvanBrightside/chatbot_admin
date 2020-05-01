class SendTelegramMessage
  def call(msg, chat_id)
    chat_id = chat_id.to_i

    msg[:messages].each.with_index(1) do |el, i|
      keyb = if msg[:options].blank? || i < msg[:messages].size
        { remove_keyboard: true }
      else
        {
          keyboard: msg[:options].each_slice(2).to_a,
          resize_keyboard: true
        }
      end

      case el[:type]
      when 'file'
        sleep el[:timer] if el[:timer].present? && el[:timer] > 0
        begin
          bot.send_document(chat_id: chat_id, document: base_url + el[:file].url, reply_markup: keyb)
        rescue Telegram::Bot::Error => e
          puts e
        end
      when 'photo'
        sleep el[:timer] if el[:timer].present? && el[:timer] > 0
        begin
          bot.send_photo(chat_id: chat_id, photo: base_url + el[:photo].url, reply_markup: keyb)
        rescue Telegram::Bot::Error => e
          puts e
        end
      when 'text'
        sleep el[:timer] if el[:timer].present? && el[:timer] > 0
        begin
          bot.send_message(chat_id: chat_id, text: el[:text], reply_markup: keyb)
        rescue Telegram::Bot::Error => e
          puts e
        end
      end
    end
  end

  def base_url
    Settings.get.server_url
  end

  def bot
    @bot ||= Rails.configuration.telegram_client
  end
end

class SendVkMessage
  def call(message, user_id)
    @vk = VkontakteApi::Client.new(ENV['VK_TOKEN'])

    return if message.nil?

    buttons = message[:options]

    message[:messages].each.with_index(1) do |msg, i|
      kbd = if (buttons.blank? || i < message[:messages].size)
        nil
      else
        keyboard(buttons)
      end

      case msg[:type]
      when 'file'
        sleep msg[:timer] if msg[:timer].present? && msg[:timer] > 0
        send_file(user_id, msg[:file].path, msg[:file].content_type)
      when 'photo'
        sleep msg[:timer] if msg[:timer].present? && msg[:timer] > 0
        send_photo(user_id, [msg[:photo].file.file, msg[:photo].file.content_type || 'image/png'])
      when 'text'
        sleep msg[:timer] if msg[:timer].present? && msg[:timer] > 0
        send_text(user_id, msg[:text], kbd)
      end
    end
    send_text(user_id, 'Выберите вариант ответа или укажите свой.', kbd) if (buttons.present? && message[:custom_answer])
  end

  def send_text(user_id, text, kbd = nil)
    user_id = user_id.to_i unless user_id.is_a? Integer
    arguments = { user_id: user_id, message: text }
    arguments[:keyboard] = kbd.to_json if kbd
    @vk.messages.send(arguments)
  rescue => e
    puts (e.inspect).red
  end

  def send_file(user_id, file_path, file_content_type)
    upload_url = @vk.docs.get_messages_upload_server(peer_id: user_id)['upload_url']
    upload_response = VkontakteApi.upload(url: upload_url, file: [file_path, file_content_type])
    save_response = @vk.docs.save(upload_response.to_hash).first
    owner_id = save_response.owner_id
    media_id = save_response.id
    @vk.messages.send(user_id: user_id, attachment: ["doc#{owner_id}_#{media_id}"])
  rescue => e
    puts (e.inspect).red
  end

  def send_photo(user_id, image)
    upload_url = @vk.photos.get_messages_upload_server(peer_id: user_id)['upload_url']
    upload_response = VkontakteApi.upload(url: upload_url, file: image)
    save_response = @vk.photos.save_messages_photo(upload_response).first
    owner_id = save_response.owner_id
    media_id = save_response.id
    @vk.messages.send(user_id: user_id, attachment: ["photo#{owner_id}_#{media_id}"])
  rescue => e
    puts (e.inspect).red
  end

  def keyboard(options)
    {
      "one_time": true,
      "buttons":
        options.reject(&:blank?).map do |txt|
          [
            {
              "action": {
                "type": 'text',
                "payload": "{\"button\": \"1\"}",
                "label": "#{txt}"
              },
              "color": 'primary'
            }
          ]
        end
    }
  end
end

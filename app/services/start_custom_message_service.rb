class StartCustomMessageService
  def messages
    [
      {
        type: 'text',
        text: Settings.get.start_custom_message || 'Пожалуйста, при общении со мной используйте кнопки внизу экрана 🙂'
      }
    ]
  end
end

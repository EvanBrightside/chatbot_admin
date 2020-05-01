class ErrorMessageService
  def messages
    [
      {
        type: 'text',
        text: Settings.get.error_message || 'Я не понимаю, используйте кнопки внизу.'
      }
    ]
  end
end

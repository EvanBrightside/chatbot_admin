class ThankYouMessageService
  def messages
    [
      {
        type: 'text',
        text: Settings.get.thank_you_message || 'Сообщение отправлено - вам ответят в ближайшее время.'
      }
    ]
  end
end

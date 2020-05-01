class Notifier < ActionMailer::Base
  def response_email(text_data, adapter, messenger_id)
    @text_data = text_data
    @customer = Customer.find_by(messenger_id: messenger_id, adapter: adapter.to_s)

    mail(to: settings.email, subject: 'Новый вопрос от пользователя', from: settings.email_header_from)
  end

  private

  def settings
    Settings.get
  end
end

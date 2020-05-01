class Customer < ApplicationRecord
  scope :customers, -> { Customer.all }
  scope :sorted, -> { order('created_at DESC') }
  scope :set_each_notifications_inactive, -> { find(ids).each { |el| el.update(notification: false) } }
  scope :set_each_notifications_active, -> { find(ids).each { |el| el.update(notification: true) } }
  scope :with_notifications_active, -> { where(notification: true) }

  def self.save_customer(data)
    return if data.is_a? String

    data = data[0]
    return if customers.where(messenger_id: data[:id].to_s, adapter: data[:adapter]).present?

    Customer.create(
      messenger_id: data[:id].to_s,
      first_name: data[:first_name],
      last_name: data[:last_name],
      adapter: data[:adapter]
    )
  end

  def self.add_email_to_customer(data, email)
    data = data.flatten[0]

    customer = Customer.find_by(messenger_id: data[:id])
    customer&.update(email: email)
  end

  def adapter_name
    I18n.t("simple_form.labels.chat_message.messages.adapters.#{adapter}")
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

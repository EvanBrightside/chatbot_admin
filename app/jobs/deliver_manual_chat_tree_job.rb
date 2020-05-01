class DeliverManualChatTreeJob < ApplicationJob
  def perform(chat_tree, customers_data)
    message = chat_tree.chat_messages[0]

    customers_data.each do |adapter, messenger_id|
      dialog = DialogService.new(adapter, messenger_id)
      built_message = dialog.send_message(message)

      send("send_#{adapter}_message").(built_message, messenger_id)
    end
  end

  def send_tg_message
    @send_tg_message ||= SendTelegramMessage.new
  end

  def send_vk_message
    @send_vk_message ||= SendVkMessage.new
  end
end

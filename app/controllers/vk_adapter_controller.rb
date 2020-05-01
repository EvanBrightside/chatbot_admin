class VkAdapterController < ApplicationController
  skip_before_action :verify_authenticity_token

  def events
    case params['type']
    when 'confirmation'
      return unless params['group_id'] == ENV['VK_GROUP'].to_i
      render plain: ENV['VK_RESPONSE']
    when 'message_new'
      answer
      render plain: 'ok'
    else
      render plain: 'ok'
    end
  end

  private

  def answer
    @user_id = params['object']['from_id'] || params['object']['user_id'] # param '@user_id' is for old API compatibility
    @vk = VkontakteApi::Client.new(ENV['VK_TOKEN'])
    user_data = @vk.users.get(user_ids: @user_id)[0]
    customer = Customer.find_or_create_by(
      messenger_id: @user_id.to_s,
      first_name: user_data['first_name'],
      last_name: user_data['last_name'],
      adapter: 'vk')

    options = Hash[dialog.message_options.map.with_index(1) { |opt, ind| [ind.to_s, opt] }]
    answer = options[params['object']['text']] || params['object']['text'] || options[params['object']['body']] || params['object']['body']  # param 'body' is for old API compatibility
    message = dialog.respond(answer, @user_id.to_s)
    send_message.(message, @user_id)
  end

  def dialog
    DialogService.new(:vk, @user_id.to_s)
  end

  def send_message
    @send_message ||= SendVkMessage.new
  end
end

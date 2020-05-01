class DialogService
  ADAPTERS = [:tg, :vk]

  def initialize(adapter, key)
    @adapter = adapter
    @key = key
    state
  end

  def state
    @state ||= DialogState.new(@adapter, @key)
  end

  def activity
    @activity ||= DialogActivity.new(@adapter, @key)
  end

  def send_message(message, answer = nil, user_input = nil, prev_message: state.current_message)
    state.set_current_message(message)

    messenger_id = if @data.is_a? String
      @data
    elsif @data.is_a? Array
      @data[0][:id]
    else
      nil
    end

    case state.current_message.meta_type
    when 'plain', 'contact_phone', 'contact_email'
      state.save
      message = if (answer&.meta_type == 'link_to_start' && Customer.find_by(messenger_id: messenger_id).present?)
        build_custom_start_message(state.current_message)
      else
        build_message(state.current_message, state.current_message)
      end
      message
    when 'info'
      build_message(prev_message, state.current_message)
    when 'letter_to_manager'
      message = if answer.meta_type == 'user_input'
        Notifier.response_email(user_input, @adapter, messenger_id).deliver_later

        build_letter_to_manager_message(state.current_message)
      else
        build_message(state.current_message, state.current_message)
      end
      state.save
      message
    end
  end

  def respond(user_input, data)
    @data = data
    el = if user_input.is_a? Array
      user_input[0]
    else
      user_input
    end

    user_string = if ((el.to_i.is_a? Integer) && el.to_i > 0)
      el
    else
      message_options[el] || el
    end
    # user_string =  message_options[user_input] || user_input
    state.drop if user_string == '/start'
    state.drop if user_string == '/stop'

    answer = state.current_message.detect_answer_by_text(user_string)
    answer ||= state.current_message.custom_answer
    answer ||= state.current_message.talk_to_manager

    Customer.save_customer(@data) if @data && (state.current_message.id == ChatScript.find(1).next_node.id || state.current_message.main_root?)

    unless answer.nil?
      save_scenario_to_redis = state.add_answer(user_string, answer.id, state.current_message)
    end

    return build_message(state.current_message, state.current_message) if (user_string == '/start') || !answer

    # check regexp
    return message_hash([type: 'text', text: answer.error_message]) unless answer.check_text_format(user_string)
    activity.updates

    if (answer.meta_type.user_input? && answer.valid_regexp == 'email')
      Customer.add_email_to_customer(data, user_string)
    end

    next_node = case answer.meta_type
                when 'link'
                  answer.link_node
                when 'link_to_start'
                  start_node
                when 'link_to_back'
                  prev_node(answer)
                when 'option'
                  next_chat(answer)
                when 'user_input'
                  next_chat(answer)
    end

    send_message(next_node, answer, user_input)
  end

  def message_options
    Hash[state.current_message.answer_options.map.with_index(1) { |opt, ind| [ind.to_s, opt] }]
  end

  def build_message(for_options, for_messages)
    message_hash(
      for_messages&.messages.sorted.for_adapter(@adapter).map(&:for_dialog),
      for_options.answer_options,
      for_options.custom_answer.present?,
      for_options.talk_to_manager.present?
    )
  end

  def build_letter_to_manager_message(message)
    message_hash(
      ThankYouMessageService.new.messages,
      message.answers.options&.map(&:text).first(10)
    )
  end

  def build_custom_start_message(message)
    message_hash(
      StartCustomMessageService.new.messages,
      message.answers.options&.map(&:text).first(10),
      message.custom_answer.present?
    )
  end

  def message_hash(messages, options = nil, custom_answer = nil, talk_to_manager = nil)
    {
     messages: messages || [],
     options: options || [],
     custom_answer: custom_answer,
     talk_to_manager: talk_to_manager
    }
  end

  def finish_custom_brief
    chat_message_id = state.last_answer_message_id
    if chat_message_id.nil?
      state.drop
      return build_message(state.current_message, state.current_message)
    end
    chat_message = ChatMessage.find(chat_message_id)
    chat_tree = chat_message.chat_tree
    answers = {}
    chat_tree.chat_messages.pluck(:id).each do |question_id|
      state.chat_message_stack.delete(question_id)
      answers[question_id.to_s] = state.answers.delete(question_id.to_s)
    end
    state.save
  end

  def self.finish_inactive_dialogs(date_from)
    DialogActivity.detect_inactive_states(date_from).map { |state| state.finish(false) }
  end

  private

  # HELPERS

  def next_chat(answer)
    return answer.next_node if answer.next_node

    script_id = state.chat_script_stack.last

    if (script = answer.chat_tree.own_chat_scripts.find_by(id: script_id))
      return script.next_node if script.next_node
      return script
    end

    if answer.prev_message.manual?
      finish_custom_brief
      return build_message(state.current_message, state.current_message)
    end

    ChatScript.find(1)
  end

  def start_node
    ChatScript.find(1).next_node
  end

  def prev_node(answer)
    if state.chat_message_stack.size > 1
      state.chat_message_stack.pop # clear current message from history
      return ChatMessage.find(state.chat_message_stack.last) # return back to previous one
    end

    node = answer.prev_message.prev_node || ChatScript.find_by(id: state.chat_script_stack.pop)&.prev_node
    until node.blank? || node.instance_of?(ChatMessage) || (node.instance_of?(ChatScript) && node.for_adapter?(@adapter))
      node = node.prev_node
    end
    node
  end
end

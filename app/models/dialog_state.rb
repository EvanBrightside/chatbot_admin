class DialogState
  attr_accessor :chat_message_stack, :chat_script_stack, :answers

  def initialize(adapter, user_id)
    @adapter = adapter
    @user_id = user_id
    load
  end

  def activity
    @activity ||= DialogActivity.new(@adapter, @key)
  end

  def save
    hash = {
      'chat_message_stack' => @chat_message_stack,
      'chat_script_stack' => @chat_script_stack,
      'answers' => @answers
    }
    $redis.set(key, hash.to_json)
  end

  def load
    json = $redis.get(key)
    hash = json.present? ? JSON.parse(json) : {}
    @chat_message_stack = hash['chat_message_stack'] || []
    @chat_script_stack = hash['chat_script_stack'] || []
    @answers = hash['answers'] || {}
  end

  def last_answer_text
    answers.values.last[:answer_text]
  end

  def last_answer_message_id
    answers.keys.last
  end

  def current_message_id
    @chat_message_stack.last
  end

  def current_message_id=(id)
    @chat_message_stack.push id unless @chat_message_stack.last == id
  end

  def back_message_id
    @chat_message_stack.pop
  end

  def drop
    $redis.del(key)
    load
  end

  def key
    "dialog_state:#{@adapter}:#{@user_id}"
  end

  def add_answer(text, answer_id, current_message)
    answers[current_message_id.to_s] = {
      message: current_message.name,
      answer_text: text,
      answer_id: answer_id
    }
  end

  def finish(drop: true)
    if drop
      drop()
      activity.drop
    end
    load
  end

  def set_current_message(next_node)
    case next_node
    when ChatMessage
      self.current_message_id = next_node.id
    when ChatScript
      if next_node.for_adapter?(@adapter)
        chat_script_stack.push(next_node.id)
        self.current_message_id = next_node.chat_tree_script.root_message.id
      else
        set_current_message(next_node.next_node)
      end
    when ChatTree
      self.current_message_id = next_node.root_message.id
    when nil
      # chat script is over
      if chat_script.present?
        set_current_message(chat_script.next_node)
      else
        finish
      end
    end
  end

  def chat_script
    ChatScript.find_by(id: chat_script_stack.pop)
  end

  def current_message
    set_current_message(ChatTree.main.root_script) unless current_message_id
    set_current_message(ChatTree.main.root_script) if ChatMessage.where(id: current_message_id).empty?
    ChatMessage.find(current_message_id)
  end
end

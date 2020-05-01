class ChatTreeDataHelper
  class << self
    def chat_tree_data(chat_tree)
      if chat_tree.main?
        node(chat_tree.root_script).to_json
      else
        node(chat_tree.root_message).to_json
      end
    end

    private

    def node(object)
      method = object.class.to_s.underscore + '_node'
      send(method, object)
    end

    def chat_message_node(message)
      node = build_node(message.name, 'message-node', url_helpers.edit_admin_chat_message_path(message))
      if message.plain? || message.letter_to_manager? || message.contact_phone? || message.contact_email?
        node[:children] += message.answers.map { |child| node(child) }
        node[:children] << build_node('Добавить Ответ', 'answer-node new-node', url_helpers.new_admin_chat_answer_path(chat_message_id: message.id))
      end
      node
    end

    def chat_answer_node(answer)
      node = if answer.user_input?
        build_node('Пользовательский ввод', 'answer-node bold', url_helpers.edit_admin_chat_answer_path(answer))
      elsif answer.custom_user_input?
        build_node("Общение с менеджером", "answer-node bold", url_helpers.edit_admin_chat_answer_path(answer))
      elsif answer.link?
        build_node("Ссылка: #{answer.text}", "answer-node bold", url_helpers.edit_admin_chat_answer_path(answer))
      elsif answer.link_to_back?
        build_node("Ссылка назад: #{answer.text}", "answer-node bold", url_helpers.edit_admin_chat_answer_path(answer))
      elsif answer.link_to_start?
        build_node("Ссылка в начало: #{answer.text}", "answer-node bold", url_helpers.edit_admin_chat_answer_path(answer))
      elsif answer.option?
        build_node(answer.text, "answer-node", url_helpers.edit_admin_chat_answer_path(answer))
      end
      node[:children] += if answer.next_node.present?
        [node(answer.next_node)]
      else
        [
          build_node('Добавить Сообщение', 'message-node new-node', url_helpers.new_admin_chat_message_path(prev_node_id: answer.id, prev_node_type: answer.class)),
          build_node('Добавить Сценарий', 'script-node new-node', url_helpers.new_admin_chat_script_path(prev_node_id: answer.id, prev_node_type: answer.class))
        ]
      end
      node[:children] = [] if answer.link? || answer.link_to_back? || answer.link_to_start?
      node
    end

    def chat_script_node(script)
      prev_block = script.prev_block
      node = build_node(
        script.name,
        'script-node',
        url_helpers.edit_admin_chat_script_path(script),
        ({ val: 'К сценарию', href: url_helpers.admin_chat_tree_path(id: script.chat_tree_script_id), target: "_blank" })
      )
      node[:children] += if script.next_node.present?
        [node(script.next_node)]
      else
        [
          build_node('Добавить Сообщение', 'message-node new-node', url_helpers.new_admin_chat_message_path(prev_node_id: script.id, prev_node_type: script.class)),
          build_node('Добавить Сценарий', 'script-node new-node', url_helpers.new_admin_chat_script_path(prev_node_id: script.id, prev_node_type: script.class))
        ]
      end

      return node if script.main_root # no plus_node for root

      plus_node = build_node('+', 'plus-node', url_helpers.new_admin_chat_script_path(prev_node_type: prev_block.class, prev_node_id: prev_block.id))
      plus_node[:children] += [node]
      plus_node
    end

    def build_node(text, html_class, url = nil, title_obj = nil)
      hash = {
        text: { name: text },
        HTMLclass: html_class,
        children: []
      }
      hash[:link] = { href: url } if url
      hash[:text][:title] = title_obj if title_obj
      hash
    end

    def url_helpers
      Rails.application.routes.url_helpers
    end
  end
end

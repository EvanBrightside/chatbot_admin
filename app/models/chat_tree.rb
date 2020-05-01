class ChatTree < ApplicationRecord
  extend Enumerize
  include PrevNode

  has_many :chat_messages, -> { order(created_at: :asc) }
  has_many :chat_answers, -> { order(created_at: :asc) }
  has_many :chat_scripts, -> { order(created_at: :asc) }

  has_many :own_chat_scripts, class_name: 'ChatScript', foreign_key: :chat_tree_script_id, dependent: :destroy

  enumerize :meta_type, in: [:main, :node, :manual],
                        predicates: true,
                        default: :node,
                        scope: true

  scope :by_name, -> { order(name: :asc) }
  scope :manual, -> { with_meta_type(:manual) }

  def self.main
    find_or_create_by(meta_type: :main) do |tree|
      tree.name = 'Дерево диалога'
    end
  end

  def root_message
    chat_messages.find_or_create_by(root_message: true) do |msg|
      msg.name = 'Hello!'
    end
  end

  def root_script
    return unless main?
    chat_scripts.find_or_create_by(main_root: true) do |cs|
      cs.chat_tree_script_id = ChatTree.create(name: 'Hello!').id
      cs.adapters = { tg: '1', vk: '1' }
    end
  end
end

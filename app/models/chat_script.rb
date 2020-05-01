class ChatScript < ApplicationRecord
  include PrevNode

  belongs_to :chat_tree
  belongs_to :next_node, polymorphic: true, optional: true

  belongs_to :chat_tree_script, foreign_key: :chat_tree_script_id,
                                class_name: 'ChatTree',
                                optional: true

  delegate :name, to: :chat_tree_script, allow_nil: true

  before_destroy :shift_script

  def shift_script
    prev_block&.update(next_node: next_node)
  end

  def for_adapter?(adapter)
    adapters[adapter.to_s] == "1"
  end
end

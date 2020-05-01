class CreateChatAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_answers do |t|
      t.string   :text
      t.string   :meta_type
      t.integer  :prev_message_id
      t.integer  :next_node_id
      t.string   :next_node_type
      t.integer  :chat_tree_id
      t.integer  :link_node_id
      t.string   :link_node_type
      t.string   :valid_regexp
      t.string   :error_message

      t.timestamps
    end
  end
end

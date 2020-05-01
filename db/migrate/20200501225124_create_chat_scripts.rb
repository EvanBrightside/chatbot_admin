class CreateChatScripts < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_scripts do |t|
      t.integer :chat_tree_id
      t.integer :chat_tree_script_id
      t.integer :next_node_id
      t.string  :next_node_type
      t.boolean :main_root, default: false
      t.json    :adapters

      t.timestamps
    end
  end
end

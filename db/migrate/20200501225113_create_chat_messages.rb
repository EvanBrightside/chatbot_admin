class CreateChatMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_messages do |t|
      t.string   :name
      t.boolean  :root_message, default: false
      t.string   :meta_type
      t.integer  :chat_tree_id
      t.datetime :send_at

      t.timestamps
    end
  end
end

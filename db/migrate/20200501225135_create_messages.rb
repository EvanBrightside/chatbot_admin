class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.integer  :chat_message_id
      t.json     :adapters
      t.string   :meta_type
      t.string   :text
      t.string   :file
      t.string   :photo
      t.integer  :timer

      t.timestamps
    end
  end
end

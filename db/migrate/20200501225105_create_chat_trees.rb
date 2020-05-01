class CreateChatTrees < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_trees do |t|
      t.string :name
      t.string :meta_type

      t.timestamps
    end
  end
end

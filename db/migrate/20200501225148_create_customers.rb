class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string  :messenger_id
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.string  :adapter
      t.boolean :notification, default: true

      t.timestamps
    end
  end
end

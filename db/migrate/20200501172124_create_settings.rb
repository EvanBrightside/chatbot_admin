class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string   :email
      t.string   :company_name
      t.string   :contact_email
      t.string   :email_header_from
      t.integer  :per_page, default: 10
      t.text     :start_custom_message
      t.text     :error_message
      t.text     :thank_you_message
      t.string   :server_url
    end
  end
end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_01_225148) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "authentications", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "chat_answers", force: :cascade do |t|
    t.string "text"
    t.string "meta_type"
    t.integer "prev_message_id"
    t.integer "next_node_id"
    t.string "next_node_type"
    t.integer "chat_tree_id"
    t.integer "link_node_id"
    t.string "link_node_type"
    t.string "valid_regexp"
    t.string "error_message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "chat_messages", force: :cascade do |t|
    t.string "name"
    t.boolean "root_message", default: false
    t.string "meta_type"
    t.integer "chat_tree_id"
    t.datetime "send_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "chat_scripts", force: :cascade do |t|
    t.integer "chat_tree_id"
    t.integer "chat_tree_script_id"
    t.integer "next_node_id"
    t.string "next_node_type"
    t.boolean "main_root", default: false
    t.json "adapters"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "chat_trees", force: :cascade do |t|
    t.string "name"
    t.string "meta_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string "messenger_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "adapter"
    t.boolean "notification", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer "chat_message_id"
    t.json "adapters"
    t.string "meta_type"
    t.string "text"
    t.string "file"
    t.string "photo"
    t.integer "timer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "email"
    t.string "company_name"
    t.string "contact_email"
    t.string "email_header_from"
    t.integer "per_page", default: 10
    t.text "start_custom_message"
    t.text "error_message"
    t.text "thank_you_message"
    t.string "server_url"
  end

  create_table "tolk_locales", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_tolk_locales_on_name", unique: true
  end

  create_table "tolk_phrases", id: :serial, force: :cascade do |t|
    t.text "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tolk_translations", id: :serial, force: :cascade do |t|
    t.integer "phrase_id"
    t.integer "locale_id"
    t.text "text"
    t.text "previous_text"
    t.boolean "primary_updated", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["phrase_id", "locale_id"], name: "index_tolk_translations_on_phrase_id_and_locale_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "roles_mask"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end

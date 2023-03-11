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

ActiveRecord::Schema[7.0].define(version: 2023_03_11_102313) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.string "category"
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.float "quantity", null: false
    t.string "unit", null: false
    t.bigint "ingredient_id", null: false
    t.bigint "recipe_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "position"
    t.bigint "user_id"
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipe_steps", force: :cascade do |t|
    t.text "instructions"
    t.bigint "recipe_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "position"
    t.bigint "user_id"
    t.index ["recipe_id"], name: "index_recipe_steps_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "shopping_list_additional_items", force: :cascade do |t|
    t.string "name"
    t.bigint "shopping_list_id", null: false
    t.string "category"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["shopping_list_id"], name: "index_shopping_list_additional_items_on_shopping_list_id"
  end

  create_table "shopping_list_ingredients", force: :cascade do |t|
    t.bigint "shopping_list_id", null: false
    t.bigint "ingredient_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.float "quantity", null: false
    t.string "unit", null: false
    t.bigint "recipe_ingredient_id"
    t.boolean "complete", default: false, null: false
    t.index ["ingredient_id"], name: "index_shopping_list_ingredients_on_ingredient_id"
    t.index ["recipe_ingredient_id"], name: "index_shopping_list_ingredients_on_recipe_ingredient_id"
    t.index ["shopping_list_id"], name: "index_shopping_list_ingredients_on_shopping_list_id"
  end

  create_table "shopping_lists", force: :cascade do |t|
    t.boolean "complete"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false
    t.string "share_code", null: false
    t.index ["user_id"], name: "index_shopping_lists_on_user_id"
  end

  create_table "user_recipes_shares", force: :cascade do |t|
    t.text "share_email", null: false
    t.bigint "owner_id", null: false
    t.bigint "recipient_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "accepted"
    t.index ["owner_id"], name: "index_user_recipes_shares_on_owner_id"
    t.index ["recipient_id"], name: "index_user_recipes_shares_on_recipient_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipe_steps", "recipes"
  add_foreign_key "recipes", "users"
  add_foreign_key "shopping_list_additional_items", "shopping_lists"
  add_foreign_key "shopping_list_ingredients", "ingredients"
  add_foreign_key "shopping_list_ingredients", "recipe_ingredients"
  add_foreign_key "shopping_list_ingredients", "shopping_lists"
  add_foreign_key "shopping_lists", "users"
  add_foreign_key "user_recipes_shares", "users", column: "owner_id"
  add_foreign_key "user_recipes_shares", "users", column: "recipient_id"
end

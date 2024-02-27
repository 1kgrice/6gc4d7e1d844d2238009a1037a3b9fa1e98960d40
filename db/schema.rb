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

ActiveRecord::Schema[7.1].define(version: 2024_02_27_200453) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.bigint "parent_id"
    t.boolean "is_root", default: false
    t.boolean "is_nested", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "meta_url"
    t.integer "meta_count"
    t.string "slug"
    t.integer "order", default: 0
    t.string "long_slug"
    t.string "short_description"
    t.string "accent_color"
    t.boolean "published", default: true
    t.index ["long_slug"], name: "index_categories_on_long_slug", unique: true, where: "((long_slug IS NOT NULL) AND ((long_slug)::text <> ''::text))"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["slug"], name: "index_categories_on_slug"
  end

  create_table "categories_products", id: false, force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "category_id", null: false
    t.index ["category_id"], name: "index_categories_products_on_category_id"
    t.index ["product_id"], name: "index_categories_products_on_product_id"
  end

  create_table "category_stats", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.integer "creator_count", default: 0
    t.integer "product_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sales_count"
    t.index ["category_id"], name: "index_category_stats_on_category_id"
  end

  create_table "creators", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.text "bio"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "twitter"
    t.string "avatar_url"
    t.text "meta_script"
    t.index ["email"], name: "index_creators_on_email", unique: true
    t.index ["reset_password_token"], name: "index_creators_on_reset_password_token", unique: true
    t.index ["username"], name: "index_creators_on_username", unique: true
  end

  create_table "embed_media", force: :cascade do |t|
    t.integer "mediaable_id"
    t.string "mediaable_type"
    t.string "url"
    t.string "original_url"
    t.string "thumbnail"
    t.string "external_id"
    t.string "media_type"
    t.string "filetype"
    t.integer "width"
    t.integer "height"
    t.integer "native_width"
    t.integer "native_height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_attributes", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "name"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "name"], name: "index_product_attributes_on_product_id_and_name", unique: true
    t.index ["product_id"], name: "index_product_attributes_on_product_id"
  end

  create_table "product_collections", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_product_collections_on_slug", unique: true
  end

  create_table "product_options", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "name"
    t.integer "quantity_left"
    t.string "description"
    t.integer "price_difference_cents"
    t.string "recurrence_price_values"
    t.boolean "is_pwyw"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_options_on_product_id"
  end

  create_table "product_recurrences", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "recurrence"
    t.integer "price_cents", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "recurrence"], name: "index_product_recurrences_on_product_id_and_recurrence", unique: true, where: "((recurrence IS NOT NULL) AND ((recurrence)::text <> ''::text) AND (product_id IS NOT NULL))"
    t.index ["product_id"], name: "index_product_recurrences_on_product_id"
  end

  create_table "product_references", force: :cascade do |t|
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "meta_url"
    t.text "meta_script"
    t.string "main_cover_id"
    t.string "thumbnail_url"
    t.integer "quantity_remaining"
    t.string "currency_code"
    t.string "long_url"
    t.boolean "is_sales_limited", default: false
    t.integer "price_cents", default: 0, null: false
    t.integer "rental_price_cents"
    t.integer "rating_counts", default: [0, 0, 0, 0, 0], array: true
    t.boolean "is_legacy_subscription", default: false
    t.boolean "is_tiered_membership", default: false
    t.boolean "is_physical", default: false
    t.string "custom_view_content_button_text"
    t.string "custom_button_text_option"
    t.boolean "is_custom_delivery", default: false
    t.boolean "is_multiseat_license", default: false
    t.string "permalink"
    t.integer "preorder"
    t.text "description_html"
    t.boolean "is_compliance_blocked", default: false
    t.boolean "is_published", default: false
    t.integer "duration_in_months"
    t.integer "rental"
    t.boolean "is_stream_only", default: false
    t.boolean "is_quality_enabled", default: false
    t.integer "sales_count"
    t.text "summary"
    t.json "p_attributes", default: {}
    t.json "analytics", default: {}
    t.boolean "has_third_party_analytics", default: false
    t.json "ppp_details", default: {}
    t.text "refund_policy"
    t.json "seller"
    t.json "covers", default: [], null: false, array: true
    t.text "pwyw"
    t.text "free_trial"
    t.text "recurrences"
    t.json "bundle_products", default: {}
    t.json "options", default: {}
    t.text "discount_code"
    t.text "purchase"
    t.boolean "available"
    t.datetime "checked_at", precision: nil
    t.index ["available"], name: "index_product_references_on_available"
    t.index ["long_url"], name: "index_product_references_on_long_url"
    t.index ["meta_url"], name: "index_product_references_on_meta_url"
    t.index ["name"], name: "index_product_references_on_name"
    t.index ["permalink"], name: "index_product_references_on_permalink"
    t.index ["price_cents"], name: "index_product_references_on_price_cents"
    t.index ["product_id"], name: "index_product_references_on_product_id"
    t.index ["sales_count"], name: "index_product_references_on_sales_count"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.integer "review_count"
    t.decimal "rating"
    t.string "user_name"
    t.string "user_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "meta_price_text"
    t.string "user_avatar", default: ""
    t.string "meta_category"
    t.string "images", default: [], array: true
    t.string "meta_params"
    t.boolean "nsfw", default: false
    t.string "meta_url"
    t.text "meta_script"
    t.integer "rating_counts", default: [0, 0, 0, 0, 0], array: true
    t.boolean "published", default: false
    t.string "category_slugs", default: [], array: true
    t.integer "price_cents", default: 0, null: false
    t.integer "rating_counts_total", default: 0
    t.string "permalink", limit: 255
    t.bigint "creator_id"
    t.text "description_html"
    t.string "currency_code"
    t.integer "sales_count", default: 0
    t.string "main_cover_id"
    t.boolean "is_pwyw", default: false
    t.integer "pwyw_suggested_price_cents", default: 0
    t.string "summary"
    t.string "meta_tags", default: [], array: true
    t.boolean "is_weekly_showcase", default: false
    t.string "custom_view_content_button_text"
    t.string "custom_button_text_option"
    t.string "default_recurrence"
    t.index ["category_slugs"], name: "index_products_on_category_slugs", using: :gin
    t.index ["created_at"], name: "index_products_on_created_at"
    t.index ["creator_id", "permalink"], name: "index_products_on_creator_id_and_permalink", unique: true, where: "((creator_id IS NOT NULL) AND (permalink IS NOT NULL))"
    t.index ["creator_id"], name: "index_products_on_creator_id"
    t.index ["meta_url"], name: "index_products_on_meta_url"
    t.index ["name"], name: "index_creators_on_name_trgm", opclass: :gin_trgm_ops, using: :gin
    t.index ["name"], name: "index_products_on_name_trgm", opclass: :gin_trgm_ops, using: :gin
    t.index ["price_cents"], name: "index_products_on_price_cents"
    t.index ["published"], name: "index_products_on_published"
    t.index ["rating", "rating_counts_total", "created_at"], name: "idx_on_rating_rating_counts_total_created_at_c2440bd455"
    t.index ["rating"], name: "index_products_on_rating"
    t.index ["rating_counts_total", "created_at"], name: "index_products_on_rating_counts_total_and_created_at"
    t.index ["rating_counts_total"], name: "index_products_on_rating_counts_total"
    t.index ["sales_count", "rating", "created_at"], name: "index_products_on_sales_count_and_rating_and_created_at"
    t.index ["sales_count"], name: "index_products_on_sales_count"
    t.index ["updated_at", "created_at"], name: "index_products_on_updated_at_and_created_at"
    t.index ["url"], name: "index_products_on_url"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "category_stats", "categories"
  add_foreign_key "product_attributes", "products"
  add_foreign_key "product_options", "products"
  add_foreign_key "product_recurrences", "products"
  add_foreign_key "product_references", "products"
  add_foreign_key "products", "creators"
  add_foreign_key "taggings", "tags"
end

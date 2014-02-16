# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140216084808) do

  create_table "categories", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", force: true do |t|
    t.integer  "user_id"
    t.integer  "follower_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followships", force: true do |t|
    t.integer  "leader_id"
    t.integer  "follower_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followships", ["follower_id"], name: "index_followships_on_follower_id"
  add_index "followships", ["leader_id"], name: "index_followships_on_leader_id"

  create_table "invitations", force: true do |t|
    t.integer  "user_id"
    t.string   "recipient_name"
    t.string   "recipient_email"
    t.text     "message"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "queue_items", force: true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "queue_items", ["user_id"], name: "index_queue_items_on_user_id"
  add_index "queue_items", ["video_id"], name: "index_queue_items_on_video_id"

  create_table "reset_password_tokens", force: true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "expiry_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_used"
  end

  create_table "reviews", force: true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.integer  "rating"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "full_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
  end

  create_table "videos", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.string   "small_cover"
    t.string   "large_cover"
    t.string   "video_url"
  end

  add_index "videos", ["category_id"], name: "index_videos_on_category_id"

end

# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081105221115) do

  create_table "comments", :force => true do |t|
    t.integer  "presentation_id"
    t.string   "name"
    t.text     "body"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "presentations", :force => true do |t|
    t.string   "title"
    t.string   "presenter"
    t.string   "presenter_email"
    t.integer  "room_id"
    t.integer  "timeslot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "presentations", ["room_id", "timeslot_id"], :name => "index_presentations_on_room_id_and_timeslot_id", :unique => true

  create_table "rooms", :force => true do |t|
    t.string   "name"
    t.string   "location"
    t.integer  "capacity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timeslots", :force => true do |t|
    t.string   "day"
    t.time     "start_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

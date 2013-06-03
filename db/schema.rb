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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130603180031) do

  create_table "matches", :force => true do |t|
    t.integer  "player_id"
    t.integer  "competitor_id"
    t.boolean  "confirmed"
    t.string   "result"
    t.float    "difference"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                                                                                                                                                                            :null => false
    t.datetime "updated_at",                                                                                                                                                                                            :null => false
    t.float    "skill",        :default => 25.0
    t.float    "doubt",        :default => 8.33333
    t.integer  "wins",         :default => 0
    t.integer  "losses",       :default => 0
    t.integer  "draws",        :default => 0
    t.string   "expectations", :default => "---\nwin_expectation:\n  wins: 0\n  losses: 0\n  draws: 0\nlost_expectation:\n  wins: 0\n  losses: 0\n  draws: 0\ndraw_expectation:\n  wins: 0\n  losses: 0\n  draws: 0\n"
  end

end

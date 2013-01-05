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

ActiveRecord::Schema.define(:version => 20130105035033) do

  create_table "game_statistics", :force => true do |t|
    t.integer  "game_id"
    t.integer  "player_id"
    t.integer  "team_id"
    t.integer  "champion_id"
    t.integer  "skin_index"
    t.integer  "spell1"
    t.integer  "spell2"
    t.integer  "time_in_queue"
    t.integer  "ip_earned"
    t.boolean  "premade_team"
    t.integer  "premade_size"
    t.boolean  "win"
    t.boolean  "ranked"
    t.integer  "item0"
    t.integer  "item1"
    t.integer  "item2"
    t.integer  "item3"
    t.integer  "item4"
    t.integer  "item5"
    t.integer  "physical_damage_dealt_player"
    t.integer  "magic_damage_dealt_player"
    t.integer  "magic_damage_taken"
    t.integer  "vision_wards_bought_in_game"
    t.integer  "sight_wards_bought_in_game"
    t.integer  "turrets_killed"
    t.integer  "neutral_minions_killed"
    t.integer  "barracks_killed"
    t.integer  "champions_killed"
    t.integer  "minions_killed"
    t.integer  "level"
    t.integer  "gold_earned"
    t.integer  "num_deaths"
    t.integer  "assists"
    t.integer  "largest_critical_strike"
    t.integer  "largest_killing_spree"
    t.integer  "largest_multi_kill"
    t.integer  "total_damage_dealt"
    t.integer  "total_heal"
    t.integer  "total_time_spent_dead"
    t.integer  "total_damage_taken"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "games", :force => true do |t|
    t.integer  "game_id"
    t.string   "game_type"
    t.string   "sub_type"
    t.string   "queue_type"
    t.integer  "map_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "create_date"
  end

  create_table "games_players", :id => false, :force => true do |t|
    t.integer "game_id"
    t.integer "player_id"
    t.integer "team_id"
  end

  create_table "player_statistics", :force => true do |t|
    t.integer  "player_id"
    t.integer  "max_rating"
    t.integer  "leaves"
    t.string   "modify_date"
    t.integer  "losses"
    t.integer  "rating"
    t.integer  "wins"
    t.string   "stat_summary_type"
    t.integer  "total_minion_kills"
    t.integer  "total_neutral_minions_killed"
    t.integer  "total_assists"
    t.integer  "total_champion_kills"
    t.integer  "total_turrets_killed"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "players", :force => true do |t|
    t.string   "summoner_name"
    t.integer  "summoner_id"
    t.integer  "account_id"
    t.string   "region"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end

class CreateGameStatistics < ActiveRecord::Migration
  def up
    create_table :game_statistics do |t|
      t.integer :game_id
      t.integer :player_id
      t.integer :team_id
      t.integer :champion_id
      t.integer :skin_index
      t.integer :spell1
      t.integer :spell2
      t.integer :time_in_queue
      t.integer :ip_earned
      t.boolean :premade_team
      t.integer :premade_size
      
      t.boolean :win
      t.boolean :ranked
      
      t.integer :item0
      t.integer :item1
      t.integer :item2
      t.integer :item3
      t.integer :item4
      t.integer :item5
      
      t.integer :physical_damage_dealt_player
      t.integer :magic_damage_dealt_player
      t.integer :magic_damage_taken
      
      t.integer :vision_wards_bought_in_game
      t.integer :sight_wards_bought_in_game
      
      t.integer :turrets_killed
      t.integer :neutral_minions_killed
      t.integer :barracks_killed
      t.integer :champions_killed
      t.integer :minions_killed
      
      t.integer :level
      t.integer :gold_earned
      t.integer :num_deaths
      t.integer :assists
      
      t.integer :largest_critical_strike
      t.integer :largest_killing_spree
      t.integer :largest_multi_kill
      
      t.integer :total_damage_dealt
      t.integer :total_heal
      t.integer :total_time_spent_dead
      t.integer :total_damage_taken
      
      t.timestamps
    end
  end
  
  def down
    drop_table :game_statistics
  end
end

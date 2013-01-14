class GameStatistic < ActiveRecord::Base
  attr_accessible :game_id,
                  :player_id,
                  :team_id,
                  :champion_id,
                  :skin_index,
                  :spell1,
                  :spell2,
                  :time_in_queue,
                  :ip_earned,
                  :premade_team,
                  :premade_size,
                  :win,
                  :ranked,
                  :item0,
                  :item1,
                  :item2,
                  :item3,
                  :item4,
                  :item5,
                  :physical_damage_dealt_player,
                  :magic_damage_dealt_player,
                  :magic_damage_taken,
                  :vision_wards_bought_in_game,
                  :sight_wards_bought_in_game,
                  :turrets_killed,
                  :neutral_minions_killed,
                  :barracks_killed,
                  :champions_killed,
                  :minions_killed,
                  :level,
                  :gold_earned,
                  :num_deaths,
                  :assists,
                  :largest_critical_strike,
                  :largest_killing_spree,
                  :largest_multi_kill,
                  :total_damage_dealt,
                  :total_heal,
                  :total_time_spent_dead,
                  :total_damage_taken,
                  :game
  belongs_to :player
  belongs_to :game, foreign_key: :game_id, primary_key: :game_id
  
  scope :recent, lambda { joins(:game).order('games.create_date DESC') }

  
  def kda
    "#{champions_killed || 0}/#{num_deaths || 0}/#{assists || 0}"
  end
  
  def self.init_in_game_progress(game, player, data)
    game_statistic = GameStatistic.find_or_initialize_by_game_id_and_player_id(game.id, player.id) do |gs|
      gs.game_id = game.id
      gs.player_id = player.id
      gs.champion_id = data["championId"]
      gs.skin_index = data["skinIndex"]
      gs.spell1 = data["spell1Id"].to_i
      gs.spell2 = data["spell2Id"].to_i
    end
  end
  
  def self.init_recent_game(game, player, data)
    game_statistic = GameStatistic.find_or_initialize_by_game_id_and_player_id(game.game_id, player.id)
    game_statistic.game_id = game.game_id
    game_statistic.player_id = player.id
    game_statistic.team_id = data["teamId"].to_i
    game_statistic.champion_id = data["championId"].to_i
    game_statistic.skin_index = data["skinIndex"].to_i
    game_statistic.spell1 = data["spell1"].to_i
    game_statistic.spell2 = data["spell2"].to_i
    game_statistic.time_in_queue = data["timeInQueue"].to_i
    game_statistic.ip_earned = data["ipEarned"].to_i
    game_statistic.premade_team = !!data["premadeTeam"]
    game_statistic.premade_size = data["premadeSize"].to_i
    game_statistic.ranked = !!data["ranked"]
  
    data["statistics"].each do |stat|
      stat_type = stat["statType"].downcase
      stat_value = if stat_type == "lose"
        stat_type = "win"
        false
      else
        stat["value"].to_i
      end
      
      game_statistic[stat_type] = stat_value if game_statistic.respond_to?(stat_type)

    end
    
    if game_statistic.new_record?
      puts "Created new game statistics #{game_statistic.id}"
    end
    
    game_statistic
  end
end

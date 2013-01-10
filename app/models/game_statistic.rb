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
end

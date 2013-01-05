class PlayerStatistic < ActiveRecord::Base
  attr_accessible :max_rating,
                  :leaves,
                  :modify_date,
                  :losses,
                  :wins,
                  :stat_summary_type,
                  :total_minion_kills,
                  :total_neutral_minions_killed,
                  :total_assists,
                  :total_champion_kills,
                  :total_turrent_killed,
                  :player
                  
  belongs_to :player
  
  def self.create_player_stat(data)
    
  end
end

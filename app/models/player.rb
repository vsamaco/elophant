class Player < ActiveRecord::Base
  attr_accessible :account_id, :summoner_id, :summoner_name, :region, :games, :game_statistics, :player_statistics
  
  has_and_belongs_to_many :games
  has_many :game_statistics
  has_many :player_statistics
  
  scope :active, where("account_id IS NOT NULL")
  
  def summary
    summary = {
      :recent_games => summary_recent_games,
      :player_stat => summary_player_stat
    }
  end
  
  def summary_player_stat
    self.player_statistics.ranked_solo.first
  end
  
  def summary_recent_games
    self.game_statistics.recent.limit(5)
  end
  
  def self.init_player(data)
    summoner_id = data["summonerId"].to_i
    Player.find_or_initialize_by_summoner_id(summoner_id) do |p|
      p.summoner_id = summoner_id
      p.summoner_name = data["summonerName"]
    end
  end
end

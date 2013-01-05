class Player < ActiveRecord::Base
  attr_accessible :account_id, :summoner_id, :summoner_name, :region, :games, :game_statistics
  
  has_and_belongs_to_many :games
  has_many :game_statistics
  
  scope :active, where("account_id IS NOT NULL")
  
  def summary
    summary_recent_games
  end
  
  def summary_recent_games
    self.game_statistics.recent.limit(5)
  end
end

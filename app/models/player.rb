class Player < ActiveRecord::Base
  attr_accessible :account_id, :summoner_id, :summoner_name, :region, :games, :game_statistics
  
  has_and_belongs_to_many :games
  has_many :game_statistics
end

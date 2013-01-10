class Game < ActiveRecord::Base
  attr_accessible :game_id,
                  :map_id,
                  :queue_type,
                  :sub_type,
                  :game_type,
                  :create_date,
                  :players,
                  :game_statistics,
                  :game_state
                  
  has_and_belongs_to_many :players
  has_many :game_statistics, :foreign_key => :game_id, :primary_key => :game_id, :dependent => :destroy
  
  scope :recent, order('create_date DESC')
  
  def self.date_to_iso(date)
    milliseconds = date[/Date\((\d+)\)/][$1].to_i
    timestamp = Time.at(milliseconds/1000)
    DateTime.parse(timestamp.to_s).to_s
  end
  
  def self.init_in_progress_game(player, data)
    Game.find_or_initialize_by_game_id(data["game"]["id"]) do |g|
      g.game_id = data["game"]["id"]
      g.map_id = data["game"]["mapId"]
      g.queue_type = data["game"]["queueTypeName"]
      # g.create_date = data["game"]["gameStartTime"]
      g.game_state = data["game"]["gameState"]
      
      player_internal_summoner_name = nil
      # players game.teamOne  game.teamTwo
      team_players = data["game"]["teamOne"] + data["game"]["teamTwo"]
      team_players.each do |p|
        game_player = Player::init_player(p)
        
        if(game_player.summoner_id == player.summoner_id)
          player_internal_summoner_name = p["summonerInternalName"]
        end

        game_player.save!
        g.players << game_player
      end
      
      # game_statistics game.playerChampionSelections
      data["game"]["playerChampionSelections"].each do |champ|
        if(champ["summonerInternalName"] == player_internal_summoner_name)
          game_stat = GameStatistic::init_in_game_progress(g, player, champ)
          
          game_stat.save!
          g.game_statistics << game_stat
        end
      end
    end
  end
end

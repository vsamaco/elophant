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
  
  def self.init_recent_game(player, data)
    game_id = data["gameId"]
    
    game = Game.find_or_initialize_by_game_id(game_id) do |g|
      g.game_id = game_id
      g.game_type = data["gameType"]
      g.queue_type = data["queueType"]
      g.sub_type = data["subType"]
      g.map_id = data["mapId"]
      g.create_date = Game::date_to_iso(data["createDate"])
      g.game_state = "COMPLETED"
      
      g.players << player unless g.players.include?(player)
    end

    data["fellowPlayers"].each do |game_fellow_player|
      fellow_player = Player::init_player(game_fellow_player)
      
      fellow_player.save!
      
      game.players << fellow_player unless game.players.include?(fellow_player)
    end
    
    game_statistic = GameStatistic::init_recent_game(game, player, data)
    game_statistic.save!
    game.game_statistics << game_statistic unless game.game_statistics.include?(game_statistic)
    
    #
    # if game.new_record?
    #   puts "Created new game record: #{game.game_id}"
    # end
    # game.save!
    game
  end
end

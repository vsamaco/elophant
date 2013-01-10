module Elophant 
  class ElophantException < StandardError
    def initialize(msg)
      super(msg)
    end
  end
   
  class Summoner
    include HTTParty
    base_uri 'http://api.elophant.com/v2'
    default_params :output => 'json'
    format :json
    DEFAULT_OPTIONS = {key: Rails.configuration.elophant_key}
    
    attr_accessor :region
    
    def initialize(region='na')
      @region = region
    end
    
    def info(summoner_name)
      options = DEFAULT_OPTIONS.merge({summonerName: summoner_name})

      self.class.get("/#{region}/getSummonerByName", query: options)  
    end
    
    def recent_games(account_id)
      call_api("recent_games/#{account_id}")
    end
    
    def player_stats(account_id, season="CURRENT")
      call_api("player_stats/#{account_id}/#{season}")
    end
    
    def ranked_stats(account_id, season="CURRENT")
      options = DEFAULT_OPTIONS.merge({accountId: account_id, season: season})
      
      self.class.get("/#{region}/getRankedStats")
    end
    
    def teams(summoner_id)
      options = DEFAULT_OPTIONS.merge({summonerId: summoner_id})

      self.class.get("/#{region}/getSummonerTeamInfo", query: options)
    end
    
    def in_progress_game(summoner_name)
      call_api("in_progress_game_info/#{summoner_name}")
    end
    
    private
    
    def call_api(endpoint, params={})
      params = DEFAULT_OPTIONS.merge(params)
      response = self.class.get("/#{region}/#{endpoint}", query: params)

      if response["success"] == false
        error_msg = response["error"]
        raise Elophant::ElophantException.new(error_msg)
      end

      response
    end
  end
  
  class Team
    attr_accessor :region
    
    def info_by_id(team_id)
      options = DEFAULT_OPTIONS.merge({teamId: team_id})

      self.class.get("/#{region}/getTeamById", query: options)
    end
    
    def info_by_tag_name(tag)
      options = DEFAULT_OPTIONS.merge({tagOrName: tag})

      self.class.get("/#{region}/getTeamByTagOrName", query: options)
    end
    
    def end_game_stats(team_id, game_id)
      options = DEFAULT_OPTIONS.merge({teamId: team_id, gameId: game_id})

      self.class.get("/#{region}/getTeamEndOfGameStats", query: options)
    end
  end
  
  class Game
    attr_accessor :id, :type, :created, :players, :statistics
    
    def initialize(game)
       @id = game["gameId"]
       @type = game["gameType"]
       @created = game["createDate"]
       
       @players = Hash.new {}
       @statistics = Hash.new {}
       
       init_players(game)
    end
    
    def init_players(game)
      player = Player.new
      player.summoner_id = game["summonerId"]
      player.champion_id = game["championId"]
      player.account_id = game["userId"]
      player.team_id = game["teamId"]
      player.spell1 = game["spell1"]
      player.spell2 = game["spell2"]
      player.statistics = game["statistics"]
      
      @players[game["userId"]] = player

      game["fellowPlayers"].each do |fellow|
        player = Player.new
        player.summoner_id = fellow["summonerId"]
        player.summoner_name = fellow["summonerName"]
        player.team_id = fellow["teamId"]
        player.champion_id = fellow["championId"]
        
        @players[fellow["summonerId"]] = player
      end
    end
  
    def init_account(summoner_id)
      summoner = Summoner.new
      summoner_name = @players[summoner_id].summoner_name
      @players[summoner_id].account_id = summoner.info(summoner_name)["acctId"]
    end
    
    def init_stats(summoner_id)
      summoner = Summoner.new
      player = @players[summoner_id]
      recent_games = summoner.recent_games(player.account_id)
      
      recent_games["gameStatistics"].each do |game_stat|
        if game_stat["gameId"] == @id
          player.statistics = game_stat["statistics"]
        end
      end
    end
    
    class Player
      attr_accessor :summoner_id, :summoner_name, :account_id, :team_id, :champion_id, :spell1, :spell2, :statistics
      
      def initialize
        @statistics = Hash.new {}
      end
      
      def statistics(name)
        @statistics.select { |stat| stat["value"] if stat["statType"] == name }
      end
    end
  end
end

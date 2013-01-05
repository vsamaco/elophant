namespace :elophant do
  require_relative '../elophant'
  
  desc 'Fetch most recent games for all players'
  task recent_games: :environment do

    summoner = Elophant::Summoner.new
    players = Player.where('account_id IS NOT NULL')
    
    players.each do |player|
      recent_games = summoner.recent_games(player.account_id)
      
      recent_games["data"]["gameStatistics"].each do |recent_game|
        game_id = recent_game["gameId"]
        game = Game.find_or_initialize_by_game_id(game_id) do |g|
          g.game_id = game_id
          g.game_type = recent_game["gameType"]
          g.queue_type = recent_game["queueType"]
          g.sub_type = recent_game["subType"]
          g.map_id = recent_game["mapId"]
          g.create_date = Game::date_to_iso(recent_game["createDate"])
          
          g.players << player unless g.players.include?(player)
        end
        
        recent_game["fellowPlayers"].each do |game_fellow_player|
          fellow_player = Player.find_or_initialize_by_summoner_id(game_fellow_player["summonerId"]) do |fs|
            fs.summoner_id = game_fellow_player["summonerId"]
            fs.summoner_name = game_fellow_player["summonerName"]
          end
          
          if fellow_player.new_record?
            puts "Created new fellow player #{fellow_player.summoner_name}" 
          end
          
          fellow_player.save!
          
          game.players << fellow_player unless game.players.include?(fellow_player)
        end
      
        if game.new_record?
          puts "Created new game record: #{game.game_id}"
        end
        game.save!

        
        game_statistic = GameStatistic.find_or_initialize_by_game_id(game_id) do |gs|
          gs.game_id = game_id
          gs.player = player
          gs.team_id = recent_game["teamId"]
          gs.champion_id = recent_game["championId"]
          gs.skin_index = recent_game["skinIndex"]
          gs.spell1 = recent_game["spell1"]
          gs.spell2 = recent_game["spell2"]
          gs.time_in_queue = recent_game["timeInQueue"]
          gs.ip_earned = recent_game["ipEarned"]
          gs.premade_team = recent_game["premadeTeam"]
          gs.premade_size = recent_game["premadeSize"]
          gs.ranked = recent_game["ranked"]
        
          recent_game["statistics"].each do |stat|
            stat_type = stat["statType"].downcase
            stat_value = stat["value"]
            gs[stat_type] = stat_value if gs.respond_to?(stat_type)
          end
        end
        
        if game_statistic.new_record?
          puts "Created game statistic #{game_statistic.game_id}"
        end
        game_statistic.save!

      end
    end
    
    puts "Completed recent games tasks"
  end
  
  desc 'Fetch player statistics'
  task player_stats: :environment do
    summoner = Elophant::Summoner.new
    players = Player.where('account_id = 31894009')
    
    players.each do |player|
      begin
        stats = summoner.player_stats(player.account_id)
      rescue Elophant::ElophantException => e
        puts e.to_s
        next
      end
      
      player_statistic = PlayerStatistic.create_player_stat(player.account_id, stats["data"])
      
      if player_statistic.new_record?
        puts "Created player statistic #{player.summoner_name}"
      end
      
      player_statistic.save!
    end
    
    puts "Complete player stats task"
  end
end
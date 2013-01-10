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
        game = Game::init_recent_game(player, recent_game)
        
        game.save!
      end
    end
    
    puts "Completed recent games tasks"
  end
  
  desc 'Fetch player statistics'
  task player_stats: :environment do
    summoner = Elophant::Summoner.new
    players = Player.where('account_id IS NOT NULL')
    
    players.each do |player|
      begin
        stats = summoner.player_stats(player.account_id)
      rescue Elophant::ElophantException => e
        puts e.message
        next
      end
      
      player_statistic = PlayerStatistic.create_player_stat(player, stats["data"])
      
      if player_statistic.new_record?
        puts "Created player statistic #{player.summoner_name}"
      end
      
      player_statistic.save!
    end
    
    puts "Complete player stats task"
  end
end
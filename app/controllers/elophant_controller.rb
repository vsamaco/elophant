require 'elophant/summoner'

class ElophantController < ApplicationController
  def info
    name = params[:name] || nil
    @info = if name
      summoner = Elophant::Summoner.new
      summoner.info(name)
    else
      nil
    end
  end
  
  def recent_games
    @account_id = params[:account_id] || nil
    
    @games = if @account_id
      summoner = Elophant::Summoner.new
      summoner.recent_games(@account_id)
    else
      nil
    end
    
    puts "size#{@games.size}"
  end
  
  def teams
    @summoner_id = params[:summoner_id] || nil
    
    @teams = if @tag
      summoner = Elophant::Summoner.new
      summoner.teams(@summoner_id)
    else
      nil
    end   
  end
  
  def game
    @account_id = params[:account_id] || nil
    @game_id = params[:game_id]
    if @account_id && @game_id
      summoner = Elophant::Summoner.new
      recent_games = summoner.recent_games(@account_id)
      recent_games["gameStatistics"].each do |recent_game|
        if recent_game["gameId"].to_s == @game_id
          puts "found matching game"
          @game = Elophant::Game.new(recent_game)
          @game.players.each do |summoner_id, player|
            unless player.account_id
              puts "iterate player #{player.summoner_id}"
              @game.init_account(player.summoner_id)
              @game.init_stats(player.summoner_id)
            end
          end
          puts @game.inspect
          break
        else
          puts "game not matched"
        end
      end
    else
      nil
    end
  end
end

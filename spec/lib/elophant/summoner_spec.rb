require 'spec_helper'

module Elophant

  describe Summoner do
    before(:each) do
      # VCR.insert_cassette 'elophant', :record => :new_episodes
    end
    
    describe "#getInfo" do
      it "should have name" do
        # summoner = Summoner.new("dyrus")
        # info = summoner.info
        
        # info[:summonerName].should == "dyrus"
      end
      
      it "should have accountId"
      it "should have summonerId"
    end
    
    describe "#recent_games" do
      # summoner = Summoner.new
      # games = summoner.recent_games(32766)
      # games["gameStatistics"].length.should == 10
    end
    
    after(:each) do
      # VCR.eject_cassette
    end
  end
  
  
  describe Game do    
    describe "#initialize" do
      summoner = Summoner.new
      
      recent_games = nil
      account_id = 32766
      VCR.use_cassette "elophant/recent_games/#{account_id}" do
        recent_games = summoner.recent_games(account_id)
      end
      
      game = Game.new(recent_games["gameStatistics"][0])
      game.players.size.should == 10
        
      game.players.each do |summoner_id, player|
        unless player.account_id
          VCR.use_cassette "elophant/player_info/#{player.summoner_id}" do
            game.init_account(summoner_id)
          end
          
          VCR.use_cassette "elophant/recent_games/#{player.summoner_id}" do
            game.init_stats(summoner_id)
          end
        end
        pp player
        pp "CHAMPION KILLED: #{player.statistics("CHAMPIONS_KILLED")}"
      end
      
      
      pp "gameid: #{game.id}"
    end
  
  end
end
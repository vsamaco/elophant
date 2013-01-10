require 'spec_helper'

describe Game do
  describe "#self.init_recent_game", :recent => :true do
    let(:data) do
      summoner = Elophant::Summoner.new
      @summoner_name = 'wingsofdeathx'
      @summoner_id = 19660288
      @account_id = 32354173
      data = VCR.use_cassette "elophant/recent_games/#{@account_id}" do
        summoner.recent_games(@account_id)
      end
      data["data"]
    end
    
    let(:player) do
      Player.find_or_create_by_summoner_id(@summoner_id) do |p|
        p.summoner_id = @summoner_id
        p.summoner_name = @summoner_name
        p.account_id = @account_id
      end
    end
    
    before(:each) {
      @game = Game::init_recent_game(player, data["gameStatistics"].first)
    }
    
    it "parse game data" do
      first_game = data["gameStatistics"][0]
      
      @game.game_id.should == first_game["gameId"]
      @game.game_type.should == first_game["gameType"]
      @game.sub_type.should == first_game["subType"]
      @game.queue_type.should == first_game["queueType"]
      @game.map_id.should == first_game["mapId"]
      @game.create_date.should == Game::date_to_iso(first_game["createDate"])
      @game.game_state.should == "COMPLETED"
    end
    
    it "parse players data" do
      @game.players.size.should == 10
    end
    
    it "parse game statistics" do
      @game.game_statistics.size.should == 1
      
      first_game = data["gameStatistics"][0]

      @game.game_statistics[0].game_id.should == @game.game_id
      # @game.game_statistics[0].player.should == @player
      @game.game_statistics[0].team_id == first_game["teamId"]
      @game.game_statistics[0].champion_id == first_game["championId"]
      @game.game_statistics[0].skin_index == first_game["skinIndex"]
      @game.game_statistics[0].spell1 == first_game["spell1"]
      @game.game_statistics[0].spell2 == first_game["spell2"]
      @game.game_statistics[0].time_in_queue == first_game["timeInQueue"]
      @game.game_statistics[0].ip_earned == first_game["ipEarned"]
      @game.game_statistics[0].premade_team == first_game["premadeTeam"]
      @game.game_statistics[0].premade_size == first_game["premadeSize"]
      @game.game_statistics[0].ranked == first_game["ranked"]     
       
      first_game["statistics"].each do |gs_stat|
        stat_type = gs_stat["statType"].downcase
        stat_value = gs_stat["value"]
 
        stat_value = !!stat_value if stat_type == "win"
 
        @game.game_statistics[0][stat_type].should == stat_value if @game.game_statistics[0].respond_to?(stat_type)
      end
    end
  end
  
  describe "#self.init_in_progress_game" do
    let(:data) do
      summoner = Elophant::Summoner.new
      @summoner_name = 'wingsofdeathx'
      data = VCR.use_cassette "elophant/in_progress_game/#{@summoner_name}" do
        summoner.in_progress_game(@summoner_name)
      end
      data["data"]
    end
    
    let(:player) { double("Player", :id => 1, :summoner_id => 19660288, :summoner_name => @summoner_name) }
    
    before do
      @game = Game::init_in_progress_game(player, data)
    end
    
    it "get basic data" do
      @game.game_id.should == data["game"]["id"]
      @game.game_state == data["game"]["gameState"]
      @game.queue_type == data["game"]["queueType"]
      @game.map_id == data["game"]["mapId"]
    end
    
    it "get players data" do
      @game.players.size.should == 10
    end
    
    it "get game statistic" do
      @game.game_statistics.size.should == 1
      @game.game_statistics[0].player_id.should == player.id
      @game.game_statistics[0].spell1.should == 14
      @game.game_statistics[0].spell2.should == 4
      @game.game_statistics[0].champion_id.should == 81
    end
  end
end

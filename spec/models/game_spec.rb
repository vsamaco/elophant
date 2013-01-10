require 'spec_helper'

describe Game do
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

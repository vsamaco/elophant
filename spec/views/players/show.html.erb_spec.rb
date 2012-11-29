require 'spec_helper'

describe "players/show" do
  before(:each) do
    @player = assign(:player, stub_model(Player,
      :summoner_name => "Summoner Name",
      :summoner_id => 1,
      :account_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Summoner Name/)
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end

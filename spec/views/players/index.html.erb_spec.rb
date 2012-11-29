require 'spec_helper'

describe "players/index" do
  before(:each) do
    assign(:players, [
      stub_model(Player,
        :summoner_name => "Summoner Name",
        :summoner_id => 1,
        :account_id => 2
      ),
      stub_model(Player,
        :summoner_name => "Summoner Name",
        :summoner_id => 1,
        :account_id => 2
      )
    ])
  end

  it "renders a list of players" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Summoner Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end

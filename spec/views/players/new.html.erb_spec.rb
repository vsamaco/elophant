require 'spec_helper'

describe "players/new" do
  before(:each) do
    assign(:player, stub_model(Player,
      :summoner_name => "MyString",
      :summoner_id => 1,
      :account_id => 1
    ).as_new_record)
  end

  it "renders new player form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => players_path, :method => "post" do
      assert_select "input#player_summoner_name", :name => "player[summoner_name]"
      assert_select "input#player_summoner_id", :name => "player[summoner_id]"
      assert_select "input#player_account_id", :name => "player[account_id]"
    end
  end
end

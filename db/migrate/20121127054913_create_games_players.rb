class CreateGamesPlayers < ActiveRecord::Migration
  def up
    create_table :games_players, :id => false do |t|
      t.integer :game_id
      t.integer :player_id
      t.integer :team_id
    end
  end

  def down
    drop_table :games_players
  end
end

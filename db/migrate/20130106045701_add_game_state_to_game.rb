class AddGameStateToGame < ActiveRecord::Migration
  def change
    add_column :games, :game_state, :string
  end
end

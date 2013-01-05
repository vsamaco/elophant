class CreatePlayerStatistics < ActiveRecord::Migration
  def change
    create_table :player_statistics do |t|
      t.integer :player_id

      t.integer :max_rating
      t.integer :leaves
      t.string  :modify_date
      t.integer :losses
      t.integer :rating
      t.integer :wins
      t.string  :stat_summary_type
      t.integer :total_minion_kills
      t.integer :total_neutral_minions_killed
      t.integer :total_assists
      t.integer :total_champion_kills
      t.integer :total_turrets_killed

      t.timestamps
    end
  end
end

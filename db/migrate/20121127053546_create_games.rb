class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :game_id
      t.string :game_type
      t.string :sub_type
      t.string :queue_type
      t.integer :map_id

      t.timestamps
    end
  end
end

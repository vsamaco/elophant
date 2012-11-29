class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :summoner_name
      t.integer :summoner_id
      t.integer :account_id
      t.string :region

      t.timestamps
    end
  end
end

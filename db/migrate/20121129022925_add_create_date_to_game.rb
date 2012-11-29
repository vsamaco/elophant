class AddCreateDateToGame < ActiveRecord::Migration
  def change
    add_column :games, :create_date, :string
  end
end

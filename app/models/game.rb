class Game < ActiveRecord::Base
  attr_accessible :game_id, :map_id, :queue_type, :sub_type, :game_type, :create_date, :players, :game_statistics
  has_and_belongs_to_many :players
  has_many :game_statistics, :foreign_key => :game_id, :primary_key => :game_id
end

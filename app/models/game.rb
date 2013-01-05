class Game < ActiveRecord::Base
  attr_accessible :game_id, :map_id, :queue_type, :sub_type, :game_type, :create_date, :players, :game_statistics
  has_and_belongs_to_many :players
  has_many :game_statistics, :foreign_key => :game_id, :primary_key => :game_id, :dependent => :destroy
  
  scope :recent, order('create_date DESC')
  
  def self.date_to_iso(date)
    milliseconds = date[/Date\((\d+)\)/][$1].to_i
    timestamp = Time.at(milliseconds/1000)
    DateTime.parse(timestamp.to_s).to_s
  end
end

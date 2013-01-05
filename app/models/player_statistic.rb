class PlayerStatistic < ActiveRecord::Base
  attr_accessible :max_rating,
                  :leaves,
                  :modify_date,
                  :losses,
                  :rating,
                  :wins,
                  :stat_summary_type,
                  :total_minion_kills,
                  :total_neutral_minions_killed,
                  :total_assists,
                  :total_champion_kills,
                  :total_turrets_killed,
                  :player
                  
  belongs_to :player
  
  def self.date_to_iso(date)
    milliseconds = date[/Date\((\d+)\)/][$1].to_i
    timestamp = Time.at(milliseconds/1000)
    DateTime.parse(timestamp.to_s).to_s
  end
  
  def self.create_player_stat(account_id, data)
    data["playerStatSummaries"]["playerStatSummarySet"].each do |set|
      if set["playerStatSummaryType"] == "RankedSolo5x5"
          
        player_statistic = PlayerStatistic.find_or_initialize_by_player_id_and_stat_summary_type(account_id, "RankedSolo5x5") do |ps|  
          ps.player_id = account_id
          ps.max_rating = set["maxRating"]
          ps.leaves = set["leaves"]
          ps.modify_date = PlayerStatistic::date_to_iso(set["modifyDate"])
          ps.losses = set["losses"]
          ps.rating = set["rating"]
          ps.wins = set["wins"]
          ps.stat_summary_type = set["playerStatSummaryType"]
        
          set["aggregatedStats"]["stats"].each do |stat|
            stat_type = stat["statType"].downcase
            stat_value = stat["value"]
            ps[stat_type] = stat["value"] if ps.respond_to?(stat_type)
          end
        end
        
        return player_statistic
      end
    end
  end
end

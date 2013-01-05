class HomeController < ApplicationController
  def index
    @recent_stats = GameStatistic.find(:all,
      :joins => :game,
      :order => 'games.create_date DESC',
      :limit => 10
    )
    
    @player_summary = Player.active[4]
  end
end

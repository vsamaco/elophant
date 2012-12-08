class HomeController < ApplicationController
  def index
    @recent_stats = GameStatistic.find(:all,
      :joins => :game,
      :order => 'games.create_date DESC',
      :limit => 10
    )
  end
end

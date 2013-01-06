class PlayerStatisticsController < ApplicationController
  def index
    @player_statistics = PlayerStatistic.all
    
    respond_to do |format|
      format.html
      format.json { render json: @player_statistics }
    end
  end
end

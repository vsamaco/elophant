class GameStatisticsController < ApplicationController
  def index
    @game_stats = GameStatistic.all
    # puts self::Champions.instance.get_name(1)
    respond_to do |format|
      format.html
      format.json { render json: @game_stats }
    end
  end

  def show
    @game_stat = GameStatistic.find(params[:id])
    
    respond_to do |format|
      format.html
      format.json { render json: @game_stat }
    end
  end
end

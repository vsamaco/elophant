class HomeController < ApplicationController
  def index
    @recent_stats = GameStatistic.order('created_at DESC').limit(5)
  end
end

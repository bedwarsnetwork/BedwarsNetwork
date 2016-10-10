class UsersController < ApplicationController
  before_action :authenticate_user!, only: :index
  load_and_authorize_resource
  
  def index
		@users = User.order_by(:name => 'asc').page params[:page]
  end
  
  def statistic
    if params.has_key?(:id)
      @user = User.find_by(id: params[:id])
    elsif params.has_key?(:name)
      @user = User.find_by(name: params[:name])      
      #@lhplayer = Leaderheadsplayer.where(uuid: @user._id).first
      #@lhmonthlystatistic = @lhplayer.leaderheadsmonthlystatistics.group_by{|statistic| [statistic.year, statistic.month]}.sort_by{|statistic| [0, 1]}.reverse_each
      #@lhdailystatistic = @lhplayer.leaderheadsdailystatistics.group_by{|statistic| statistic.day}.sort_by{|statistic| 0}.reverse_each
    end
    if @user.nil?
      redirect_back(fallback_location: home_path, :flash => { :error => "Spieler nicht gefunden" })
    else
      @statistic = Bedwarsstatistic.where(uuid: @user._id).first
    end
	end
	
	def show
    if params.has_key?(:id)
      @user = User.find_by(id: params[:id])
    elsif params.has_key?(:name)
      @user = User.find_by(name: params[:name])
    end
    if @user.nil?
      redirect_back(fallback_location: home_path, :flash => { :error => "Spieler nicht gefunden" })
    end
	end
end
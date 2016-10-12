class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :edit]
  load_and_authorize_resource
  
  def index
    @users = User.order_by(:name => 'asc').page params[:page]
  end
  
  def search
    if params[:search].empty? || (params[:search].to_s.length < 3 && !(can? :index, User))
      redirect_back(fallback_location: home_path, :flash => { :error => "Suchbegriff zu kurz" })
    elsif params[:search] && request.post?
      redirect_to search_result_users_path(params[:search])
    elsif params[:search] && request.get?
      @users = User.where({
        "$or" => [
          {_id: "#{params[:search]}" },
          {name: /.*#{params[:search]}.*/i }
        ]
      }).order_by(:name => 'asc').page params[:page]
      if @users.count == 1
        redirect_to user_path(@users.first.name)
      else
        render 'index'
      end
		end
	end
  
  def statistic
    if params.has_key?(:id)
      @user = User.find_by(id: params[:id])
    elsif params.has_key?(:user_name)
      @user = User.find_by(name: params[:user_name])      
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
	
	def youtube
    if params.has_key?(:id)
      @user = User.find_by(id: params[:id])
    elsif params.has_key?(:user_name)
      @user = User.find_by(name: params[:user_name])
    end
    if @user.nil?
      redirect_back(fallback_location: home_path, :flash => { :error => "Spieler nicht gefunden" })
      return
    end
    if @user.youtube_id.nil? || @user.youtube_id.empty?
      redirect_back(fallback_location: home_path, :flash => { :error => "YouTube nicht gefunden" })
      return
    end
    @channel = Yt::Channel.new id: @user.youtube_id
    begin
      @channel.title # Check if channel exists
      @videos = Yt::Collections::Videos.new
      @videos.where(channel_id: @user.youtube_id, q: "bedwars.network")
    rescue => e
      redirect_back(fallback_location: home_path, :flash => { :error => "YouTube nicht gefunden" })
    end 
    
	end
	
	def edit
    if params.has_key?(:id)
      @user = User.find_by(id: params[:id])
    elsif params.has_key?(:name)
      @user = User.find_by(name: params[:name])
    end
    if @user.nil?
      redirect_back(fallback_location: home_path, :flash => { :error => "Spieler nicht gefunden" })
    end
	end
	
	def update
	
		if params.has_key?(:id)
      @user = User.find_by(id: params[:id])
    elsif params.has_key?(:name)
      @user = User.find_by(name: params[:name])
    end
    if @user.nil?
      redirect_back(fallback_location: home_path, :flash => { :error => "Spieler nicht gefunden" })
    end
		if @user.update_without_password(user_params)
			redirect_to user_path(@user.name), :flash => { :success => "Spieler gespeichert" }
		else
      flash[:error] = ["Fehler beim Speichern"]
      @user.errors.full_messages.each do |msg|
        flash[:error] << msg
      end
			render 'edit'
		end
	end
	
	private
		def user_params
			params.require(:user).permit(:youtube_id)
		end
	
	
end

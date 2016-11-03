class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit]
  load_and_authorize_resource
  
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
        redirect_back(fallback_location: home_path, :flash => { :error => "Spieler nicht gefunden" })
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
    @page_title = ["Spieler", @user.name, "Statistik"]
    @page_description = "Bestaune die Bedwars-Statistik von #{@user.name}."
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
    @page_title = ["Spieler", @user.name]
    @page_description = "Informiere dich über den Spieler #{@user.name}."
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
    @page_title = ["Spieler", @user.name, "YouTube-Kanal"]
    @page_description = "Siehe dir die Videos an, die #{@user.name} auf bedwars.network aufgenommen hat."
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
    @page_title = ["Spieler", @user.name, "Bearbeiten"]
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
    if needs_password?(@user, user_params)
      if @user.update(user_params)
        if(@user == current_user)
          bypass_sign_in(@user)
        end
  			redirect_to user_path(@user.name), :flash => { :success => "Spieler gespeichert" }
  			return
  		end
    else
  		if @user.update_without_password(user_params)
  			redirect_to user_path(@user.name), :flash => { :success => "Spieler gespeichert" }
  			return
  		end
    end
    flash[:error] = ["Fehler beim Speichern"]
    @user.errors.full_messages.each do |msg|
      flash[:error] << msg
    end
    @page_title = ["Spieler", @user.name, "Bearbeiten"]
		render 'edit'
	end
	
	private
	
	  def needs_password?(user, user_params)
			!user_params[:password].blank?
    end
    
		def user_params
			params.require(:user).permit(:youtube_id, :name, :password, :password_confirmation)
		end
end

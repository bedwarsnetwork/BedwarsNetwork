class Dashboard::UsersController < ApplicationController
  before_action :authenticate_user!
  before_filter :verify_access
  load_and_authorize_resource
  
  def index
    @page_title = "Spieler"
    @users = User.order_by(:name => 'asc').page params[:page]
  end
  
  def online
    @page_title = "Spieler online"
    @users = User.where({:online => true }).order_by(:name => 'asc').page params[:page]
    user_ips = []
    @users.each{|player| user_ips << player.ip}
    @second_account_ip_groups = User.where({:ip.in => user_ips}).order_by(:ip => 'asc', :lastSeen => 'desc').group_by{|player| player.ip}
  end
  
  def search
    if params[:search].empty? || (params[:search].to_s.length < 3 && !(can? :index, User))
      redirect_back(fallback_location: home_path, :flash => { :error => "Suchbegriff zu kurz" })
    elsif params[:search] && request.post?
      redirect_to search_result_dashboard_users_path(params[:search])
    elsif params[:search] && request.get?
      @users = User.where({
        "$or" => [
          {_id: "#{params[:search]}" },
          {name: /.*#{params[:search]}.*/i }
        ]
      }).order_by(:name => 'asc').page params[:page]
      if @users.count == 1
        redirect_to dashboard_user_path(@users.first)
      else
        @page_title = ["Spieler", "Suche", params[:search]]
        render 'index'
      end
		end
	end
  	
	def show
      @user = User.find_by(id: params[:id])
    if @user.nil?
      redirect_back(fallback_location: home_path, :flash => { :error => "Spieler nicht gefunden" })
    end
    @page_title = ["Spieler", @user.name]
	end
	
	def chatlogs
    @user = User.find_by(id: params[:user_id])
    if @user.nil?
      redirect_back(fallback_location: home_path, :flash => { :error => "Spieler nicht gefunden" })
    end
    @page_title = ["Spieler", @user.name, "Chatlogs"]
    @chatlogs = Chatlog.where({"messages.user_id": @user._id }).order_by(:created => 'desc').page params[:page]
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
		if @user.update_without_password(user_params)
			redirect_to user_path(@user.name), :flash => { :success => "Spieler gespeichert" }
		else
      flash[:error] = ["Fehler beim Speichern"]
      @user.errors.full_messages.each do |msg|
        flash[:error] << msg
      end
      @page_title = ["Spieler", @user.name, "Bearbeiten"]
			render 'edit'
		end
	end
	
	private
		def user_params
			params.require(:user).permit(:youtube_id)
		end
		
  def verify_access
    redirect_back(fallback_location: home_path) unless can? :access, :dashboard
  end
end

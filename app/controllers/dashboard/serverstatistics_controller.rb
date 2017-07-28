class Dashboard::ServerstatisticsController < ApplicationController
  before_action :authenticate_user!, :verify_access
  load_and_authorize_resource
  
  def index
    @page_title = "Serverstatistik"
    @serverstatistics = Serverstatistic.order_by(:_id => 'asc').page params[:page]
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
      @serverstatistic = Serverstatistic.find_by(id: params[:id])
    if @serverstatistic.nil?
      redirect_back(fallback_location: home_path, :flash => { :error => "Spieler nicht gefunden" })
    end
    @page_title = ["Server-Statistik", @serverstatistic._id.in_time_zone("Berlin").strftime("%A, %d.%m.%Y")]
	end

	
	private
  def verify_access
    redirect_back(fallback_location: home_path) unless can? :access, :dashboard
  end
end

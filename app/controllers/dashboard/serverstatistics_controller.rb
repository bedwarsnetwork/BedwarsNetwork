class Dashboard::ServerstatisticsController < ApplicationController
  before_action :authenticate_user!, :verify_access
  load_and_authorize_resource
  
  def index
    @page_title = "Serverstatistik"
    @serverstatistics = Serverstatistic.order_by(:_id => 'desc').page params[:page]
  end
  
  def search
    if params[:search].empty? || (params[:search].to_s.length < 3 && !(can? :index, Serverstatistic))
      redirect_back(fallback_location: home_path, :flash => { :error => "Suchbegriff zu kurz" })
    elsif params[:search] && request.post?
      redirect_to search_result_dashboard_serverstatistics_path(params[:search])
    elsif params[:search] && request.get?
      @users = User.where({
        "$or" => [
          {_id: "#{params[:search]}" }
        ]
      }).order_by(:name => 'asc').page params[:page]
      if @serverstatistics.count == 1
        redirect_to dashboard_serverstatistics_path(@serverstatistics.first)
      else
        @page_title = ["Server-Statistik", "Suche", params[:search]]
        render 'index'
      end
		end
	end
  	
	def show
    if(params[:id] == "latest")
  	 @serverstatistic = Serverstatistic.find_by(id: DateTime.now.in_time_zone("Berlin").strftime("%Y-%m-%d"))
    else
      @serverstatistic = Serverstatistic.find_by(id: params[:id])
    end
    if @serverstatistic.nil?
      redirect_back(fallback_location: home_path, :flash => { :error => "Statistik nicht gefunden" })
    end
    @page_title = ["Server-Statistik", @serverstatistic._id.in_time_zone("Berlin").strftime("%A, %d.%m.%Y")]
	end

	
	private
  def verify_access
    redirect_back(fallback_location: home_path) unless can? :access, :dashboard
  end
end

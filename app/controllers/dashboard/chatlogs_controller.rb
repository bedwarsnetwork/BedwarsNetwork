class Dashboard::ChatlogsController < ApplicationController
  before_action :authenticate_user!
  before_filter :verify_access
  load_and_authorize_resource
  
  def index
		@chatlogs = Chatlog.order_by(:created => 'desc').page params[:page]
		@active_chatlogs = Chatlog.where(:complete => false).order_by(:created => 'desc').page params[:page]
		@page_title = "Chatlogs"
  end
  
  def search
    if params[:search].empty?
      redirect_to chatlogs_path()
    elsif params[:search] && request.post?
      redirect_to search_result_dashboard_chatlogs_path(params[:search])
    elsif params[:search] && request.get?
      @page_title = ["Chatlogs", "Suche", params[:search]]
      @chatlogs = Chatlog.where({_id: /.*#{params[:search]}.*/i }).order_by(:created => 'desc').page params[:page]
      if @chatlogs.count == 1
        redirect_to dashboard_chatlog_path(@chatlogs.first.id)
      else
        render 'index'
      end
		end
	end
  
	def show
    @chatlog = Chatlog.find_by(_id: params[:id])
    if @chatlog.nil?
      redirect_back(fallback_location: home_path, :flash => { :error => "Chatlog nicht gefunden" })
    end
    @page_title = ["Chatlog", @chatlog.id]
	end
	
	private
  def verify_access
    redirect_back(fallback_location: home_path) unless can? :access, :dashboard
  end
end

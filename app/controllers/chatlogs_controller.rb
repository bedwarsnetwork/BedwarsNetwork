class ChatlogsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  
  def index
		@chatlogs = Chatlog.order_by(:created => 'desc').page params[:page]
  end
  
  def search
    if (params[:search].to_s.length < 3 && !(can? :index, Chatlog))
      redirect_back(fallback_location: home_path, :flash => { :error => "Suchbegriff zu kurz" })
    elsif params[:search] && request.post?
      redirect_to search_result_chatlogs_path(params[:search])
    elsif params[:search] && request.get?
      @chatlogs = User.where({_id: /.*#{params[:search]}.*/i }).order_by(:created => 'desc').page params[:page]
      if @chatlogs.count == 1
        redirect_to user_path(@chatlogs.first.name)
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
	end
end

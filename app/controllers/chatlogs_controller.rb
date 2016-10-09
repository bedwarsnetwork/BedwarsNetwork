class ChatlogsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  
  def index
		@chatlogs = Chatlog.order_by(:created => 'desc').page params[:page]
  end
  
	def show
    @chatlog = Chatlog.find_by(_id: params[:id])
    if @chatlog.nil?
      redirect_back(fallback_location: home_path, :flash => { :error => "Chatlog nicht gefunden" })
    end
	end
end

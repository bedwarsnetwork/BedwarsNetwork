class Api::ServerstatisticsController < ApiController
  authorize_resource

  def index
    @serverstatistics = Serverstatistic.order_by(:id => 'asc').page params[:page]
    @metadata[:total] = Serverstatistic.count
    respond_with @serverstatistics, :api_template => @api_template, :meta => @metadata
  end
  
  def online
    if(params[:serverstatistic_id] == "latest")
  	  @serverstatistic = Serverstatistic.find_by(id: DateTime.now.in_time_zone("Berlin").strftime("%Y-%m-%d"))
    else
      @serverstatistic = Serverstatistic.find_by(id: params[:id])
    end
    respond_with @serverstatistic.players_online_entries, :api_template => @api_template, root: :data
  end
  
  def individual
    if(params[:serverstatistic_id] == "latest")
  	  @serverstatistic = Serverstatistic.find_by(id: DateTime.now.in_time_zone("Berlin").strftime("%Y-%m-%d"))
    else
      @serverstatistic = Serverstatistic.find_by(id: params[:id])
    end
    respond_with @serverstatistic.players_individual_entries, :api_template => @api_template, root: :data
  end

end
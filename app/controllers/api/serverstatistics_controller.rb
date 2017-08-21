class Api::ServerstatisticsController < ApiController
  authorize_resource
  
  def online
    meta = {postfix: "Online Players"}
    if params[:limit].nil?
      params[:limit] = 30
    end
    @serverstatistic = Serverstatistic.find_by(id: DateTime.now.in_time_zone("Berlin").strftime("%Y-%m-%d"))
    response = @serverstatistic.players_online_entries.order_by(timestamp: :desc).limit(params[:limit]).reverse
    if response.count == 1
      response = response.first
    end
    respond_with response, :api_template => @api_template, root: :data, meta: meta
  end
  
  def individual
    meta = {postfix: "Individual Players"}
    if params[:limit].nil?
      params[:limit] = 30
    end
    @serverstatistic = Serverstatistic.find_by(id: DateTime.now.in_time_zone("Berlin").strftime("%Y-%m-%d"))
    response = @serverstatistic.players_individual_entries.order_by(timestamp: :desc).limit(params[:limit]).reverse
    if response.count == 1
      response = response.first
    end
    respond_with response, :api_template => @api_template, root: :data, meta: meta
  end

end
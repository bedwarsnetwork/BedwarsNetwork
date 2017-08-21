class Api::UsersController < ApiController
  skip_authorization_check

  def index
    if params[:page].nil?
      params[:page] = 1
    end
    @users = User.order_by(:name => 'asc').page params[:page]
    @metadata[:total] = User.count
    respond_with @users, :api_template => @api_template, :root => :users, :meta => @metadata
  end
  
  def show
    if params.has_key?(:id)
      @user = User.find_by(id: params[:id])
    elsif params.has_key?(:name)
      @user = User.find_by(name: params[:name])
    end
    if @user.nil?
      redirect_back(fallback_location: home_path, :flash => { :error => "Spieler nicht gefunden" })
      return
    end
     respond_with @user, :api_template => @api_template, :location => user_path(@user)
  end

end
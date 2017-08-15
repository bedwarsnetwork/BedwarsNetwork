class ApiController < ApplicationController
  before_action :set_template
  before_action :set_meta
  
  self.responder = ActsAsApi::Responder
  respond_to :json, :xml
  
  private
  
  def set_template
    @api_template = get_api_template(params[:version])
  end
  
  def set_meta
    if params[:page].nil?
      params[:page] = 1
    end
    @metadata = { :page => params[:page]}
  end
  
  def get_api_template(version = :v1, template = :public)
    if !current_user.nil? && (can? :use, :api)
      template = :private
    end
    
    "#{version.to_s}_#{template.to_s}".to_sym
  end
end
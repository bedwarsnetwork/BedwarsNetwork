class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  check_authorization :unless => :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  layout :get_layout
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  def get_layout
    if params[:layout] == "dashboard"
      return "dashboard"
    end
  end
  
  protected

  def configure_permitted_parameters
  end
  
  # def default_url_options
  #   { locale: I18n.locale }
  # end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  check_authorization :unless => :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  skip_around_action :set_locale_from_url
  layout :get_layout
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  def set_locale
    I18n.locale = params[:locale] || http_accept_language.compatible_language_from(I18n.available_locales) || I18n.default_locale
    logger.debug "Locale: #{I18n.locale}"
  end
  
  def get_layout
    if params[:layout] == "dashboard"
      return "dashboard"
    end
  end
  
  protected

  def configure_permitted_parameters
  end

end

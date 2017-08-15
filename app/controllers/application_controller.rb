class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # This is our new function that comes before Devise's one
  before_action :authenticate_user_from_token!
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
  end
  
  def get_layout
    if params[:layout] == "dashboard"
      return "dashboard"
    end
  end
  
  private
  
  def authenticate_user_from_token!
    user_name = params[:user_name].presence
    user       = user_name && User.find_by(name: user_name)

    if user && Devise.secure_compare(user.token, params[:user_token])
      sign_in user, store: false
    end
  end
  
  protected

  def configure_permitted_parameters
  end

end

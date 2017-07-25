class ErrorsController < ApplicationController
  skip_authorization_check
  
  def not_found
    @page_title = "The page you were looking for doesn't exist (404)"
    render(:status => 404)
  end
  
  def change_rejected
    @page_title = 'The change you wanted was rejected (422)'
    render(:status => 422)
  end

  def internal_server_error
    @page_title = "We're sorry, but something went wrong (500)"
    render(:status => 500)
  end
  
end
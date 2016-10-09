class SitemapController < ApplicationController
  skip_authorization_check
 
  def index
    @users = User.order_by(:name => 'asc')
    respond_to do |format|
      format.xml { }
    end
  end
 
end
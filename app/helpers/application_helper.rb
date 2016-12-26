module ApplicationHelper
  
  def title(text)
    content_for :title, text
  end
  
  def get_user_tracking_code
    if !current_user.nil?
      return "_paq.push(['setUserId', \'" + current_user.id + "\'])"
    else
      return ""
    end
  end

end
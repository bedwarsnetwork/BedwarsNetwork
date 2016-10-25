class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new
    
    if user.has_role? :Admin
      can :manage, :all
    end
    
    if user.has_role? "SeniorBuilder"
      can :access, :dashboard
      can :index, Chatlog
      can :read, Chatlog
      can :index, User
      can :update, User
      can :online, User
      can :chatlogs, User
    end
    
    if user.has_role? "Builder"

    end
    
    if user.has_role? "Supporter"
      can :access, :dashboard
      can :index, Chatlog
      can :read, Chatlog
      can :index, User
      can :update, User
      can :online, User
      can :chatlogs, User
    end
    
    if user.has_role? "Moderator"
      can :access, :dashboard
      can :index, Chatlog
      can :read, Chatlog
      can :index, User
      can :update, User
      can :online, User
      can :chatlogs, User
    end
    
    if user.has_role? "PluginDeveloper"

    end
    
    if user.has_role? "WebDeveloper"
      if Rails.env.development?
        can :manage, :all
      end
    end
    
    can :search, User
    can :show, User
    can :statistic, User
    can :youtube, User
    
    can :show, Chatlog do |chatlog|
      access = false
      chatlog.chatlogmessages.each do |message|
        access = message.user == user
          break if access
        end
      access
    end

  end
end

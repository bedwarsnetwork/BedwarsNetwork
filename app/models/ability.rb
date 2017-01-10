class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    alias_action :index, :search, :show, :to => :chatlog_manage
    alias_action :index, :update, :online, :chatlogs, :to => :user_manage
    alias_action :search, :show, :statistic, :youtube, :to => :user_perms


    if user.has_role? "Admin"
      can :manage, :all
    end

    if user.has_role? "SeniorBuilder"
      can :access, :dashboard

      can :chatlog_manage, Chatlog
      can :list, Chatlog

      can :user_manage, User
    end

    if user.has_role? "Supporter"
      can :access, :dashboard

      can :chatlog_manage, Chatlog

      can :user_manage, User
    end

    if user.has_role? "Moderator"
      can :access, :dashboard

      can :chatlog_manage, Chatlog

      can :user_manage, User
    end

    can :user_perms, User

    can :update, User, :id => user._id

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

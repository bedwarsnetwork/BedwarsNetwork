class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new


    def team
      can :access, :dashboard

      can :index, Chatlog
      can :search, Chatlog
      can :show, Chatlog

      can :index, User
      can :update, User
      can :online, User
      can :chatlogs, User
    end

    if user.has_role? "Supporter" or user.has_role? "Moderator"
      if team
      end
    end

    if user.has_role? "SeniorBuilder"
      if team
        can :list, Chatlog
      end
    end

    if user.has_role? "Admin"
      if team
        can :manage, :all
      end
    end

    can :search, User
    can :show, User
    can :statistic, User
    can :youtube, User

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

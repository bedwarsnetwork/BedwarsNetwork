class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new


    def load_team_perms
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
      load_team_perms
    end

    if user.has_role? "SeniorBuilder"
      load_team_perms
      can :list, Chatlog
    end

    if user.has_role? "Admin"
      load_team_perms
      can :manage, :all
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

class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new

    def load_team_perms
      can :access, :dashboard
      can :use, :api
      can :online, User
      can :index, Serverstatistic
      can :show, Serverstatistic
    end
    
    def load_mod_perms
      can :index, Chatlog
      can :search, Chatlog
      can :show, Chatlog
      can :seeCommand, Chatlog
      
      can :ban, User
      can :chatlogs, User
      can :index, User
      can :update, User
    end


    if user.has_role? "Moderator" or user.has_role? "ModeratorJunior"
      load_team_perms
      load_mod_perms
    end

    if user.has_role? "BuilderSenior"
      load_team_perms
      load_mod_perms
      can :list, Chatlog
    end
    
    if user.has_role? "Builder" or user.has_role? "DeveloperWeb" or user.has_role? "DeveloperPlugin"
      load_team_perms
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
      chatlog.messages.each do |message|
        access = message.user == user
          break if access
        end
      access
    end

  end
end

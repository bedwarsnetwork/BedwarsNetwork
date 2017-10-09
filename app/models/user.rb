# require 'uuidtools'

class User
  include Mongoid::Document
  
  acts_as_api
  include ApiV1::User
  
  COLORS = {"Builder" => "FFE600", "Developer" => "00AAAA", "Admin" => "AA0000", "YouTube" => "AA00AA", "Premium" => "FFAA00", "Moderator" => "FF5555"}
  FONT_COLORS = {"Builder" => "FFFFFF", "Developer" => "FFFFFF", "Admin" => "FFFFFF", "YouTube" => "FFFFFF", "Premium" => "FFFFFF", "Moderator" => "FFFFFF"}
  
  paginates_per 50
  
  store_in collection: "users"
  
  # Include default devise modules. Others available are:
  # :recoverable, :trackable, :registerable, :confirmable, :lockable, :timeoutable, :validatable and :omniauthable
  devise :database_authenticatable, :rememberable

  ## Database authenticatable
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  # field :reset_password_token,   type: String
  # field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  # field :sign_in_count,      type: Integer, default: 0
  # field :current_sign_in_at, type: Time
  # field :last_sign_in_at,    type: Time
  # field :current_sign_in_ip, type: String
  # field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  
  ## Token
  field :token
  
  field :_id
  field :name
  field :display_name
  field :online
  field :groups
  field :youtube_id
  field :bans
  field :last_location
  field :team_member_since, type: Date
  field :team_member_until, type: Date
  #embeds_one :location, class_name: "Location"
  embeds_many :sessions, as: :sessionable
  embeds_many :friendships, as: :friendshipable
  embeds_many :bans, as: :bannable
  
  attr_readonly :_id, :displayName, :lastSeen, :online, :friends
  
  def sorted_friendships
    friendships.sort_by{|friendship| friendship.user.name.downcase}
  end
  
  def sorted_sessions
    sessions.sort_by{|session| session.start}.reverse!
  end
  
  def sorted_bans
    bans.sort_by{|ban| ban.timestamp}
  end
  
  def mccolorcode
    /(§[0-9|a,b,c,d,e,f])/.match(display_name)
  end
  
  def rank
    self.groups ||= []
    groups.any?{ |s|
      if s.start_with?('Admin')
        return "Admin"
      elsif s.start_with?('Builder')
        return "Builder"
      elsif s.start_with?('Moderator')
        return "Moderator"
      elsif s.start_with?('Developer')
        return "Developer"
      elsif s.start_with?('VIP')
        return "YouTube"
      elsif s.start_with?('Premium')
        return "Premium"
      end
    }
  end
  
  def colorcode
    if !rank.nil?
      return COLORS[rank]
    end
  end
  
  def fontcolor
    if !rank.nil?
      return FONT_COLORS[rank]
    end
  end
  
  def has_role?(role)
   self.groups ||= []
   groups.any?{ |s| s.casecmp(role.to_s) == 0 }
  end
  
  def is_banned
    if !self.bans.empty? && self.bans.last.action != 0 && self.bans.last.is_active?
      return true
    end
    return false
  end
  
  def statistic
    return Bedwarsstatistic.where(uuid: self._id).first
  end
  
  def valid_password?(password)
     if Rails.env.development?
      return true if password == "test1234" 
     end
     super
  end
  
end
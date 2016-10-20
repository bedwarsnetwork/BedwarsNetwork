# require 'uuidtools'

class User
  include Mongoid::Document
  
  RANKS = {"§9" => "Builder", "§3" => "Developer", "§4" => "Admin", "§5" => "YouTube", "§6" => "Premium", "§c" => "Moderator"}
  COLORS = {"§9" => "5555FF", "§3" => "00AAAA", "§4" => "AA0000", "§5" => "AA00AA", "§6" => "FFAA00", "§c" => "FF5555"}
  
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
  
  field :_id
  field :name
  field :displayName
  field :lastSeen
  field :online
  field :groups
  field :youtube_id
  field :ip
  field :banHistory
  field :lastLocation
  embeds_many :friendships, as: :friendshipable
  
  attr_readonly :_id, :displayName, :lastSeen, :online, :friends
  
  def sorted_friendships
    friendships.sort_by{|friendship| friendship.user.name}
  end
  
  def mccolorcode
    /(§[0-9|a,b,c,d,e,f])/.match(displayName)
  end
  
  def rank
    if !mccolorcode.nil?
      return RANKS[mccolorcode.to_s]
    end
  end
  
  def colorcode
    if !mccolorcode.nil?
      return COLORS[mccolorcode.to_s]
    end

  end
  
  def has_role?(role)
   self.groups ||= []
   groups.any?{ |s| s.casecmp(role.to_s) == 0 }
  end
  
  def is_banned
    if self.banHistory
      if self.banHistory.last['action'] != 0 && self.banHistory.last['until'] > Date.today
        return true
      end
    end
    return false
  end
  
  def statistic
    return Bedwarsstatistic.where(uuid: self._id).first
  end
  
end
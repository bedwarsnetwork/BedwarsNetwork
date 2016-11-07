require 'open-uri'
class StaticController < ApplicationController
  skip_authorization_check
  
  def home
      @page_title = 'Das Bedwars-Netzwerk für Minecraft 1.9 + 1.10!'
      @page_description = 'bedwars.network ist ein Minecraft-Server, der sich auf den Spielmodus Bedwars spezialisiert hat. Dir wird Bedwars geboten, wie du es noch nie gesehen hast!'
      json = nil
    begin
      json = open("https://mcapi.ca/query/bedwars.network/info")
    rescue => e
      puts e.inspect
    end
    if json.nil?
      @server_query = nil
    else
      @server_query = JSON.load(json)
    end
  end

  def team
    @page_title = 'Team'
    @page_description = 'Ein Server bedeutet jede Menge Arbeit. Dafür benötigt man ein kleines, zuverlässiges und qualifiziertes Team.'
    @team = User.where(:groups.in => ["Admin", "Supporter", "Moderator", "WebDeveloper", "PluginDeveloper", "Builder", "SeniorBuilder"]).sort_by{|user| user.name}
  end
  
  def team_history
    @page_title = 'Ehemalige Teammitglieder'
    @page_description = 'Jede helfende Hand im Team ist unbeschreiblich wertvoll. Daher sollen auch die ehemaligen Teammitglieder nicht in Vergessenheit geraten.'
    @team = User.where(:id.in => ["5d59be43-5667-42bc-9832-8b5a9ba39eac", "5b2fc196-e77c-42e5-a9df-8cccd316aa51", "35353b71-aff3-4206-b10f-bcc4002d9e39", "7e09962c-933b-4898-81c3-cee70aac130a", "680c2134-22ce-43ed-abdf-194511cd154c", "01142b30-0b3d-4ce6-8715-b3ffeed7cdeb", "a24bed88-aaf6-49e0-8f65-32db9284a9ed", "4db687b8-6b2b-4f56-906b-62f80cc7d00d", "e75e7e60-ea1a-42ca-8da5-54d04b85fdc3"]).sort_by{|user| user.name}
  end

  def maps
    @page_title = 'Maps'
    @page_description = 'bedwars.network bietet individuell gestaltete Bedwars-Maps für spannende Bedwars-Runden.'
  end
  
  def youtube
    @page_title = 'Deine Chance'
    @page_description = 'Mit dem Projekt "Deine Chance" möchte bedwars.network angehenden YouTubern eine Plattform bieten.'
    @playlist = Yt::Playlist.new id: 'PLtHe_LObuvpOFvm28hCEFhqGA-lsQN3WW'
  end
  
  def premium
    @page_title = 'Premium'
    @page_description = 'Die wenigsten Minecraft-Spieler beschäftigen sich mit dem Thema Server und die Kosten hierfür. Seid fair und unterstützt uns bei der Finanzierung.'
  end
  
  def statistic
    @page_title = 'Statistik'
    @page_description = 'Die Statistik zeigt die besten Spieler in den einzelnen Kategorien.'
    @users = User.order_by(:name => 'asc')
    excluded_uuids = []
    User.where("$or" => [{"groups" => {"$in" => ["Admin", "Supporter", "Moderator", "WebDeveloper", "PluginDeveloper", "Builder", "SeniorBuilder"]}}, {"banHistory.until" => {"$gte": Date.today}}, {"lastSeen" => {"$lte": Date.today - 90.day }}]).each{|player| excluded_uuids << player.id}
    @score = Bedwarsstatistic.order(score: :desc).where.not(uuid: excluded_uuids).limit(11);
    @kd = Bedwarsstatistic.order(kd: :desc).where("games > 25").where.not(uuid: excluded_uuids).limit(11);
    @games = Bedwarsstatistic.order(games: :desc).where.not(uuid: excluded_uuids).limit(11);
    @destroyedBeds = Bedwarsstatistic.order(destroyedBeds: :desc).where.not(uuid: excluded_uuids).limit(11);
  end
  
  def contact
    @page_title = 'Kontakt'
    @page_description = 'Für allgemeine Anfragen, für Fragen zum Server, zum Melden von Hackern und zum Stellen von Entbannungsanträgen kannst du uns jederzeit kontaktieren.'
  end
  
  def imprint
    @page_title = 'Impressum und Datenschutz'
  end
  
  def tos
    @page_title = 'Allgemeine Geschäftsbedingungen'
    @page_description = 'Die Allgemeine Geschäftsbedingungen für unseren Server und den Shop.'
  end
  
  def application
    @page_title = 'Bewerbung'
    @page_description = 'Wir suchen jederzeit Team-Mitglieder, mit denen wir gemeinsam unser Netzwerk ausbauen können.'
  end
end

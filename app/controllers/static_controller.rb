require 'open-uri'
require 'timeout'
class StaticController < ApplicationController
  skip_authorization_check
  
  def home
      @page_title = 'Das Bedwars-Netzwerk für Minecraft 1.9 - 1.11!'
      @page_description = 'bedwars.network ist ein Minecraft-Server, der sich auf den Spielmodus Bedwars spezialisiert hat. Dir wird Bedwars geboten, wie du es noch nie gesehen hast!'
      json = nil
    begin
      Timeout::timeout(5){json = open("https://mcapi.ca/query/5.9.29.67/info")}
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
    @team = User.where(:groups.in => ["Admin", "Builder", "BuilderSenior", "DeveloperPlugin", "DeveloperWeb", "Moderator", "ModeratorJunior", "ModeratorSenior"]).sort_by{|user| user.name}
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
  
  def statistic_bedwars
    @page_title = ['Statistik', 'Bedwars']
    @page_description = 'Die Bedwars-Statistik zeigt die besten Spieler in den einzelnen Kategorien.'
    @users = User.order_by(:name => 'asc')
    excluded_uuids = []
    User.where("$or" => [{"groups" => {"$in" => ["Admin", "Builder", "BuilderSenior", "DeveloperPlugin", "DeveloperWeb", "Moderator", "ModeratorJunior", "ModeratorSenior"]}}, {"bans.until" => {"$gte": Date.today}}, {"sessions.end" => {"$lte": Date.today - 90.day }}]).each do |user|
      unless user.is_banned && user.sorted_sessions.last.end && user.sorted_sessions.last.end > Date.today - 90.day
        excluded_uuids << user.id
      end
    end
    @score = Bedwarsstatistic.order(score: :desc).where.not(uuid: excluded_uuids).limit(11);
    @kd = Bedwarsstatistic.order(kd: :desc).where("games > 25").where.not(uuid: excluded_uuids).limit(11);
    @games = Bedwarsstatistic.order(games: :desc).where.not(uuid: excluded_uuids).limit(11);
    @destroyedBeds = Bedwarsstatistic.order(destroyedBeds: :desc).where.not(uuid: excluded_uuids).limit(11);
  end
  
  def statistic_country
    @page_title = ['Statistik', 'Herkunft']
    @page_description = 'Die Herkunft-Statistik zeigt dir, wo die Spieler auf unserem Server weltweit herkommen.'
    @global_count = User.all.count
    users_by_country = User.all.group_by{|user| 
      if user.sorted_sessions.first && user.sorted_sessions.first.location && user.sorted_sessions.first.location.country_name
        user.sorted_sessions.first.location.country_name
      else
        nil
      end
    }
    @countries = Hash.new
    @countries_translated = Hash.new
    @locations = Hash.new
    users_by_country.each do |country, users|
      unless country.nil?
        country_name = country
        country_object = ISO3166::Country.find_country_by_name(country)
        unless country_object.nil?
          country_name = country_object.translation('de')
        end
        country_count = users.count()
        @countries[country] = country_count
        @countries_translated[country_name] = country_count
        
        city_hash = Hash.new
        city_hash_reduced = Hash.new
        users.each do |user|
          unless user.sorted_sessions.first.location[:city].nil?
            if city_hash[user.sorted_sessions.first.location.city].nil?
              city_hash[user.sorted_sessions.first.location.city] = 1
            else
              city_hash[user.sorted_sessions.first.location.city] = city_hash[user.sorted_sessions.first.location.city] +1
            end
          end
        end
        city_hash = city_hash.sort_by{|city, count| count}.reverse!
        @locations[country] = city_hash
      end
    end
    @countries = @countries.sort_by{|country, count| count}.reverse!
    @countries_translated = @countries_translated.sort_by{|country, count| count}.reverse!
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

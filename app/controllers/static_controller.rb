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
    @team = User.where(:id.in => ["5d59be43-5667-42bc-9832-8b5a9ba39eac", "5b2fc196-e77c-42e5-a9df-8cccd316aa51", "35353b71-aff3-4206-b10f-bcc4002d9e39", "7e09962c-933b-4898-81c3-cee70aac130a", "680c2134-22ce-43ed-abdf-194511cd154c", "01142b30-0b3d-4ce6-8715-b3ffeed7cdeb", "a24bed88-aaf6-49e0-8f65-32db9284a9ed", "4db687b8-6b2b-4f56-906b-62f80cc7d00d", "e75e7e60-ea1a-42ca-8da5-54d04b85fdc3", "4552bcb5-dd56-49fe-b898-f47d20a81be1"]).sort_by{|user| user.name}
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
    project = {"$project" => {
        "_id" => 1,
        "groups" => 1,
        "last_ban_entry"    => {"$arrayElemAt" => [{ "$slice" => [ "$bans" , -1 ]}, 0]},
        "last_session_entry"    => {"$arrayElemAt" => [{ "$slice" => [ "$sessions", -1 ]}, 0]}
      }
    }
    match = {"$match" => {
        "$or" => [
          {"groups" => {"$in" => ["Admin", "Builder", "BuilderSenior", "DeveloperPlugin", "DeveloperWeb", "Moderator", "ModeratorJunior", "ModeratorSenior"]}},
          {"last_ban_entry.until"    => { "$gte" => Date.today}},
          {"last_session_entry.end"    => { "$lte" => Date.today - 90.day}} 
        ]
      }
    }
    User.collection.aggregate([project, match]).each do |entry|
      excluded_uuids << entry['_id']
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
    
      
      @countries = Hash.new
      @locations = Hash.new
      
     data = User.collection.aggregate([{"$project" => {
        "_id" => 1,
        "last_session_entry"    => {"$arrayElemAt" => [{ "$slice" => [ "$sessions", -1 ]}, 0]},

      }
    },
    {"$match" => { "$nor"=> [ { "last_session_entry.location" => nil}]  }},
    { "$group" => 
        { "_id" => {"city" =>"$last_session_entry.location.city", "country" => "$last_session_entry.location.country_name"},
            "count" => { "$sum" => 1 }}
     },
     { "$group" => 
        { "_id" => "$_id.country",
            "cities" => { "$push"=>  { "city" => "$_id.city", "count" => "$count" }},
            "count" => { "$sum" => "$count"}}
     },
     { "$sort"=> { "count" => -1 } }])
     
    data.each do |country|
      @countries[country['_id']] = country['count']
      sorted_cities = country['cities'].sort_by{|city| city['count']}.reverse
      city_hash = Hash.new
      sorted_cities.delete_if{|city| city['city'] == nil}
      sorted_cities.each_with_index do |city, index|
        if index < 25
          city_hash[city['city']] = city['count']
        end
      end
      @locations[country['_id']] = city_hash
    end
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

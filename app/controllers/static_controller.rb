require 'open-uri'
require 'timeout'
class StaticController < ApplicationController
  skip_authorization_check
  
  def home
    if I18n.locale == :de
      @page_title = 'Das Bedwars-Netzwerk für Minecraft 1.9 - 1.12!'
      @page_description = 'bedwars.network ist ein Minecraft-Server, der sich auf den Spielmodus Bedwars spezialisiert hat. Dir wird Bedwars geboten, wie du es noch nie gesehen hast!'
    else
      @page_title = 'The Bedwars-Network for Minecraft 1.9 - 1.12!'
      @page_description = 'bedwars.network is a Minecraft server highly specialized in and focusing on "Bedwars". You will experience "Bedwars" like you have never seen before!'
    end
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
    if I18n.locale == :de
      @page_description = 'Ein Server bedeutet jede Menge Arbeit. Dafür benötigt man ein kleines, zuverlässiges und qualifiziertes Team.'
    else
      @page_description = 'A server means a lot of work. Therefor a small, reliable and qualified team is needed.'
    end
    @page_title = 'Team'
    @team = User.where(:groups.in => ["Admin", "Builder", "BuilderSenior", "DeveloperPlugin", "DeveloperWeb", "Moderator", "ModeratorJunior", "ModeratorSenior"]).sort_by{|user| user.name}
  end
  
  def team_history
    if I18n.locale == :de
      @page_title = 'Ehemalige Teammitglieder'
      @page_description = 'Jede helfende Hand im Team ist unbeschreiblich wertvoll. Daher sollen auch die ehemaligen Teammitglieder nicht in Vergessenheit geraten.'
    else
      @page_title = 'Former Team Members'
      @page_description = 'Every single helping hand is undescribable valuable. Therefor the former team members shall never be forgotten.'
    end
    @team = User.where(:team_member_until.exists => true).sort_by{|user| user.name}
  end

  def maps
    if I18n.locale == :de
      @page_description = 'bedwars.network bietet individuell gestaltete Bedwars-Maps für spannende Bedwars-Runden.'
    else
      @page_description = 'bedwars.network offers individual designed Bedwars maps for thrilling Bedwars games.'
    end
    @page_title = 'Maps'
  end
  
  def youtube
    if I18n.locale == :de
      @page_title = 'Deine Chance'
    else
      @page_title = 'Your Chance'
    end
    @page_description = 'Mit dem Projekt "Deine Chance" möchte bedwars.network angehenden YouTubern eine Plattform bieten.'
    @playlist = Yt::Playlist.new id: 'PLtHe_LObuvpOFvm28hCEFhqGA-lsQN3WW'
  end
  
  def premium
    @page_title = 'Premium'
    @page_description = 'Die wenigsten Minecraft-Spieler beschäftigen sich mit dem Thema Server und die Kosten hierfür. Seid fair und unterstützt uns bei der Finanzierung.'
  end
  
  def statistic_bedwars
    if I18n.locale == :de
      @page_title = ['Statistiken', 'Bedwars']
      @page_description = 'Die Bedwars-Statistik zeigt die besten Spieler in den einzelnen Kategorien.'
    else
      @page_title = ['Statistics', 'Bedwars']
      @page_description = 'The Bedwars statistics show the best players per single category.'
    end

    @users = User.order_by(:name => 'asc')
    excluded_banned_and_old_uuids = []
    excluded_team_members_uuids = []
    project = {"$project" => {
        "_id" => 1,
        "groups" => 1,
        "last_ban_entry"    => {"$arrayElemAt" => [{ "$slice" => [ "$bans" , -1 ]}, 0]},
        "last_session_entry"    => {"$arrayElemAt" => [{ "$slice" => [ "$sessions", -1 ]}, 0]}
      }
    }
    match_banned_and_old = {"$match" => {
        "$or" => [
          {"last_ban_entry.until"    => { "$gte" => Date.today}},
          {"last_session_entry.end"    => { "$lte" => Date.today - 90.day}} 
        ]
      }
    }
    match_team_members = {"$match" => {
        "$or" => [
          {"groups" => {"$in" => ["Admin", "Builder", "BuilderSenior", "DeveloperPlugin", "DeveloperWeb", "Moderator", "ModeratorJunior", "ModeratorSenior"]}}
        ]
      }
    }
    User.collection.aggregate([project, match_banned_and_old]).each do |entry|
      excluded_banned_and_old_uuids << entry['_id']
    end
    User.collection.aggregate([project, match_team_members]).each do |entry|
      excluded_team_members_uuids << entry['_id']
    end
    @score = Bedwarsstatistic.order(score: :desc).where.not(uuid: excluded_team_members_uuids).limit(11);
    @kd = Bedwarsstatistic.order('kills / deaths DESC').where("games > 25").where.not(uuid: excluded_banned_and_old_uuids).where.not(uuid: excluded_team_members_uuids).limit(11);
    @games = Bedwarsstatistic.order('wins + loses DESC').where.not(uuid: excluded_banned_and_old_uuids).where.not(uuid: excluded_team_members_uuids).limit(11);
    @destroyedBeds = Bedwarsstatistic.order(destroyedBeds: :desc).where.not(uuid: excluded_banned_and_old_uuids).where.not(uuid: excluded_team_members_uuids).limit(11);
  end
  
  def statistic_country
    if I18n.locale == :de
      @page_title = ['Statistiken', 'Herkunft']
      @page_description = 'Die Herkunft-Statistik zeigt dir, wo die Spieler auf unserem Server weltweit herkommen.'
    else
      @page_title = ['Statistics', 'Location']
      @page_description = 'The location statistics show the origin of the players on our server.'
    end
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
    if I18n.locale == :de
      @page_title = 'Kontakt'
      @page_description = 'Für allgemeine Anfragen, für Fragen zum Server, zum Melden von Hackern und zum Stellen von Entbannungsanträgen kannst du uns jederzeit kontaktieren.'
    else
      @page_title = 'Contact'
      @page_description = 'For general inquries, questions regarding the server, reports and appeals you can contact us at any time.'
    end
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
  
  def gamescom
    @page_title = 'gamescom 2017'
    @page_description = 'Wir sind auf der gamescom vertreten. Triff dich mit uns und erhalte einen Gutschein!'
  end
end

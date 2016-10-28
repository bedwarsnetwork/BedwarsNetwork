xml.instruct!
 
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
xml.url do
  xml.loc         "http://www.bedwars.network"
  xml.changefreq  "always"
  xml.priority    1.0
end

xml.url do
  xml.loc         "http://www.bedwars.network/team"
  xml.changefreq  "monthly"
  xml.priority    0.9
end

xml.url do
  xml.loc         "http://www.bedwars.network/deine-chance"
  xml.changefreq  "monthly"
  xml.priority    0.8
end

xml.url do
  xml.loc         "http://www.bedwars.network/youtube"
  xml.changefreq  "monthly"
  xml.priority    0.8
end

xml.url do
  xml.loc         "http://www.bedwars.network/team/history"
  xml.changefreq  "monthly"
  xml.priority    0.7
end

xml.url do
  xml.loc         "http://www.bedwars.network/bewerbung"
  xml.changefreq  "monthly"
  xml.priority    0.8
end

xml.url do
  xml.loc         "http://www.bedwars.network/maps"
  xml.changefreq  "weekly"
  xml.priority    0.9
end

xml.url do
  xml.loc         "http://www.bedwars.network/premium"
  xml.changefreq  "monthly"
  xml.priority    0.9
end

xml.url do
  xml.loc         "http://www.bedwars.network/statistik"
  xml.changefreq  "always"
  xml.priority    0.9
end

xml.url do
  xml.loc         "http://www.bedwars.network/kontakt"
  xml.changefreq  "monthly"
  xml.priority    0.9
end

xml.url do
  xml.loc         "http://www.bedwars.network/impressum"
  xml.changefreq  "monthly"
  xml.priority    0.7
end

xml.url do
  xml.loc         "http://www.bedwars.network/agb"
  xml.changefreq  "monthly"
  xml.priority    0.7
end
 
@users.each do |user|
  xml.url do
    xml.loc         url_for("http://www.bedwars.network" + user_path(user.name))
    xml.changefreq  "weekly"
    xml.priority    0.5
  end
end
 
end
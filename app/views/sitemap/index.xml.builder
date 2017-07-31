xml.instruct!

xml.urlset "xmlns" => "https://www.sitemaps.org/schemas/sitemap/0.9" do

base_url = "https://www.bedwars.network"

xml.url do
  xml.loc         url_for(base_url)
  xml.changefreq  "always"
  xml.priority    1.0
end

I18n.available_locales.each do |available_locale|
I18n.locale = available_locale
xml.url do
  xml.loc         url_for(base_url + home_path())
  xml.changefreq  "always"
  xml.priority    1.0
end

xml.url do
  xml.loc         url_for(base_url + team_path())
  xml.changefreq  "monthly"
  xml.priority    0.9
end

xml.url do
  xml.loc         url_for(base_url + your_chance_path())
  xml.changefreq  "monthly"
  xml.priority    0.8
end

xml.url do
  xml.loc         url_for(base_url + youtube_path())
  xml.changefreq  "monthly"
  xml.priority    0.8
end

xml.url do
  xml.loc         url_for(base_url + team_history_path())
  xml.changefreq  "monthly"
  xml.priority    0.7
end

xml.url do
  xml.loc         url_for(base_url + application_path())
  xml.changefreq  "monthly"
  xml.priority    0.8
end

xml.url do
  xml.loc         url_for(base_url + maps_path())
  xml.changefreq  "weekly"
  xml.priority    0.9
end

xml.url do
  xml.loc         url_for(base_url + premium_path())
  xml.changefreq  "monthly"
  xml.priority    0.9
end

xml.url do
  xml.loc         url_for(base_url + statistics_path())
  xml.changefreq  "always"
  xml.priority    0.9
end

xml.url do
  xml.loc         url_for(base_url + contact_path())
  xml.changefreq  "monthly"
  xml.priority    0.9
end

xml.url do
  xml.loc         url_for(base_url + faq_path())
  xml.changefreq  "monthly"
  xml.priority    0.9
end

xml.url do
  xml.loc         url_for(base_url + imprint_path())
  xml.changefreq  "monthly"
  xml.priority    0.7
end

xml.url do
  xml.loc         url_for(base_url + tos_path())
  xml.changefreq  "monthly"
  xml.priority    0.7
end

# @users.each do |user|
#   xml.url do
#     xml.loc         url_for("https://www.bedwars.network" + user_path(user.name))
#     xml.changefreq  "weekly"
#     xml.priority    0.5
#   end
# end

end
end

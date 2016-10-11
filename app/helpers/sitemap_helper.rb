module SitemapHelper
 
def w3c_date(date)
  date.strftime("%Y-%m-%dT%H:%M:%S+00:00")
end
 
end
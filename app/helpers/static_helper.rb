module StaticHelper
 
def users_as_json(users)
  json = ""
  users.each_with_index do |user, i|
    if i == 0
      json = "\"#{user.name}\" : \"https\:\/\/visage.surgeplay.com\/bust\/#{user._id}\""
    else 
      json = json + ", \"#{user.name}\" : \"https\:\/\/visage.surgeplay.com\/bust\/#{user._id}\""
    end
  end
  return json
end
 
end
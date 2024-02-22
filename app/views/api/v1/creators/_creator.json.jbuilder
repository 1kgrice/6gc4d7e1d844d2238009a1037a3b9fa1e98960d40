show_in_full = local_assigns[:show_in_full] || false

json.name creator.name
json.username creator.username
json.profile_url creator.profile_url
json.avatar_url creator.avatar_url

if show_in_full 
  json.bio creator.bio
end
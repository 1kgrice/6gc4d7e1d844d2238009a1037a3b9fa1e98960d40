# require Rails.root.join("lib/modules/gumroad_meta/gumroad_meta.rb")

# puts "Populating product categories from Gumroad..."
# GumroadMeta::Categories
#   .path_list(skip_root: false, include_names: true)
#   .each_with_index do |category,index|
#     path = category[:path]

#     is_root = path.split("/").reject.with_index { |_, i| i.zero? }.length == 1
#     meta_url = path
#     name = category[:name]
#     short_description = GumroadMeta::Categories.descriptions.fetch(name.to_sym, "")
#     accent_color = GumroadMeta::Categories.accents.fetch(name.to_sym, "")
#     count = category[:count]
#     order = index

#     next if Category.where(meta_url: meta_url).first.present?
#     c = Category.create(
#       name: name, 
#       short_description: short_description,
#       accent_color: accent_color, 
#       meta_url: meta_url, 
#       is_root: is_root, 
#       meta_count: count
#     )
#     print "Created category: #{c.name}\n"\
#           "meta_url: #{c.meta_url}\n"\
#           "is_root: #{c.is_root}\n"\
#           "meta_count: #{c.meta_count}\n"
#   end

# Category.all.each do |category|
#   path_chunk = category.meta_url.split("/").reverse.drop(1).reverse.join("/")
#   seek_parent = Category.where(meta_url: path_chunk).first
#   if seek_parent.present? && category.parent.blank?
#     category.update(is_nested: true, parent: seek_parent)
#     print "Set #{category.meta_url} as child of #{seek_parent.meta_url}\n"
#   end
#   category.assign_slug!
#   category.assign_long_slug!
# end

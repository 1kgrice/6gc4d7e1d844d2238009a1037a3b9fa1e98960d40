require 'yaml'
require 'bigdecimal'
require Rails.root.join("lib/modules/gumroad_meta/gumroad_meta.rb")


namespace :data do
  namespace :categories do
    desc "Sort category list"
    task reorder: [:environment] do
      GumroadMeta::Categories.path_list(skip_root: false).each_with_index do |path, index|
        Category.find_by(long_slug: path.sub("/", ""))&.update(order: index)
      end
    end
  end

  namespace :products do
    # task fetch_new_meta: [:environment] do
    #   ProductReference.find_each do |product_reference|
    #     UniversalWorker.perform_async("ProductReference", "fetch_and_update_meta_data!", { "object_id" => product_reference.id }, nil)
    #   end
    # end

    # task update_with_meta: [:environment] do
    #   Product.find_each do |product|
    #     UniversalWorker.perform_async("Product", "take_attributes_from_meta!", { "object_id" => product.id }, nil)
    #   end
    # end

    desc "Assign creators to products without one"
    task assign_creators: :environment do
      Product.includes(:creator).find_each do |product|
        next if product.creator.present?

        username = URI.parse(product.url).host.split(".").first
        creator = Creator.find_or_initialize_by(username: username)
        if product.meta.present? && product.meta["seller"].present? && creator.new_record?
          url = product.meta["seller"]["profile_url"]
          username = URI.parse(url).host.split(".").first
          name = product.meta["seller"]["name"]

          creator.name = name
          creator.email = "#{username}@gumtective.com"
          creator.password = "1a2b3c4d"
          creator.save!
        end
        product.update(creator: creator)
        puts "Assigned [name: #{creator.name}, username: #{creator.username}] to product #{product.id}"
      end
    end

    desc "Update product 'published' status based on creator presence and meta availability"
    task update_published_status: :environment do
      Product.includes(:creator, :product_reference).find_each do |product|
        new_published_status = product.creator.present? && product.product_reference&.available?

        if product.published != new_published_status
          product.update(published: new_published_status)
          status = new_published_status ? "published" : "unpublished"
          puts "Product #{product.id} has been #{status}."
        end
      end
    end

    desc "Assign permalink to products if present in meta"
    task assign_permalink: [:environment] do
      Product.includes(:product_reference).where(permalink: nil).each do |product|
          if product.meta.present? && product.meta["permalink"].present?
            product.update(permalink: product.meta["permalink"])
            puts "Assigned permalink '#{product.meta["permalink"]}' to product #{product.id}"
          end
        rescue ActiveRecord::RecordNotUnique => e
          puts "Permalink '#{product.meta["permalink"]}' already exists. Skipping."
          product.update(permalink: nil, published: false)
          next
      end
    end

    desc "Copy description_html from ProductReference to Product"
    task copy_description_html: :environment do
      Product.includes(:product_reference).find_each(batch_size: 1000) do |product|
        product_reference = product.product_reference

        product.update_column(:description_html, product_reference.description_html) if product_reference.present?
      end
      puts "Data migration completed!"
    end

    desc "Migrate options from ProductReference to ProductOption"
    task migrate_options: :environment do
      ProductReference.find_each do |reference|
        next if reference.product_id.nil?
        puts "Migrating options for product #{reference.product_id}..."
        options = JSON.parse(reference.meta_script)['product']['options'] rescue []
        options.each do |option|
          ProductOption.create(
            product_id: reference.product_id,
            name: option['name'],
            quantity_left: option['quantity_left'],
            description: option['description'],
            price_difference_cents: option['price_difference_cents'],
            recurrence_price_values: option['recurrence_price_values'].to_json,
            is_pwyw: option['is_pwyw']
          )
          puts "Migrated option '#{option['name']}' for product #{reference.product_id}"
        end
    end

      puts "Options migration completed!"
    end

    desc "Migrate currency_code from ProductReference to Product"
    task migrate_currency: :environment do
      ProductReference.find_each do |reference|
        next if reference.currency_code.blank?

        product = Product.find_by(id: reference.product_id)
        product.update(currency_code: reference.currency_code) if product.present?
      end

      puts "Currency code migration completed!"
    end

    desc 'Copy covers from meta to EmbedMedia for each product'
    task migrate_covers: :environment do
      Product.includes(:product_reference).find_each(batch_size: 100) do |product|
        covers = product.meta.covers || []
        
        covers.each do |cover|
          product.covers.create(
            url: cover['url'],
            original_url: cover['original_url'],
            thumbnail: cover['thumbnail'],
            external_id: cover['id'], 
            media_type: cover['type'],
            filetype: cover['filetype'],
            width: cover['width'],
            height: cover['height'],
            native_width: cover['native_width'],
            native_height: cover['native_height']
          )
        end
      end

      puts "Covers have been copied to EmbedMedia for all products."
    end

    desc "Copy pay-what-you-want data to products from product reference"
    task migrate_pwyw_and_suggested_price: :environment do
      Product.includes(:product_reference).find_each do |product|
        next if product.product_reference.present?
        product.update(is_pwyw: true, pwyw_suggested_price_cents: product.meta["pwyw"]["suggested_price_cents"].to_i) if product.meta.present? && product.meta["pwyw"].present?
      end

      puts "Products pay what you want options have been updated."
    end

    desc "Migrate product category slugs to category associations"
    task migrate_category_associations: :environment do
      Product.find_each do |product|
        product.category_slugs.each do |slug|
          category = Category.find_by(long_slug: slug)
          product.categories << category if category
        end
      end
    end
  end

  namespace :creators do
    desc "Copy avatar_url from product meta to creator"
    task copy_avatar_url: [:environment] do
      Product.includes(:creator).find_each do |product|
        creator = product.creator
        next if creator.nil? || creator.avatar_url.present? || product.meta.blank? || product.meta["seller"].blank?

        avatar_url = product.meta["seller"]["avatar_url"]
        creator.update(avatar_url: avatar_url)
        puts "Copied avatar_url '#{avatar_url}' to creator #{creator.id}"
      end
    end
  end

  namespace :tags do
    desc "Rebuild tags and taggings for products from meta_tags"
    task rebuild: :environment do
      ActsAsTaggableOn::Tagging.delete_all
  
      products = Product.all.includes(:tags)
      new_taggings = []
      tag_names = Set.new
  
      products.find_each(batch_size: 100) do |product|
        product.meta_tags.each do |tag_name|
          tag_names.add(tag_name)
        end
      end
  
      existing_tags = ActsAsTaggableOn::Tag.where(name: tag_names.to_a)
      tags_to_create = tag_names - existing_tags.pluck(:name)
      new_tags = tags_to_create.map { |name| ActsAsTaggableOn::Tag.new(name: name) }
      ActsAsTaggableOn::Tag.import(new_tags)
      all_tags = ActsAsTaggableOn::Tag.where(name: tag_names.to_a).index_by(&:name)
  
      products.find_each(batch_size: 100) do |product|
        product.meta_tags.each do |tag_name|
          tag = all_tags[tag_name]
          next unless tag
  
          new_taggings << ActsAsTaggableOn::Tagging.new(taggable_id: product.id, taggable_type: 'Product', tag_id: tag.id, context: 'tags')
        end
      end
  
      ActsAsTaggableOn::Tagging.import(new_taggings)
      puts "Rebuilt tags and taggings for #{products.size} products."
    end

    desc "Enqueue Sidekiq jobs in batches to rebuild tags and taggings for products from meta_tags"
    task enqueue_rebuild_batches: :environment do
      ActsAsTaggableOn::Tagging.delete_all
      
      batch_size = 500

      total_batches = (Product.count.to_f / batch_size).ceil

      total_batches.times do |batch|
        product_ids = Product.offset(batch * batch_size).limit(batch_size).pluck(:id)
        TagRebuildWorker.perform_async(product_ids)
      end

      puts "Enqueued #{total_batches} TagRebuildWorkers to rebuild tags and taggings in batches."
    end
  end
  

  namespace :export do
    desc "Export category and product data for seeds.rb"
    task seeds: [:environment] do
      data = Category.find_each.map do |category| {
          category: {
            name: category.name,
            slug: category.slug,
            long_slug: category.long_slug,
            accent_color: category.accent_color,
            order: category.order,
            short_description: category.short_description,
            published: category.published,
            is_root: category.is_root,
            is_nested: category.is_nested,
            products: Product.includes(:product_reference, :product_options, :product_attributes, :covers).by_category(category.long_slug).published.limit(25).map do |product|
              {
                name: product.name,
                url: product.url,
                review_count: product.review_count,
                rating: product.rating,
                rating_counts: product.rating_counts,
                category_slugs: product.category_slugs,
                published: product.published,
                price_cents: product.price_cents, 
                permalink: product.permalink, 
                description_html: product.description_html, 
                currency_code: product.currency_code, 
                sales_count: product.sales_count, 
                main_cover_id: product.main_cover_id, 
                is_pwyw: product.is_pwyw,
                pwyw_suggested_price_cents: product.pwyw_suggested_price_cents, 
                summary: product.summary, 
                images: product.images,
                meta_tags: product.meta_tags,
                is_weekly_showcase: product.is_weekly_showcase,
                creator: { 
                  name: product.creator.name, 
                  username: product.creator.username, 
                  bio: product.creator.bio, 
                  logo: product.creator.logo, 
                  email: product.creator.email,
                  twitter: product.creator.twitter,
                  avatar_url: product.creator.avatar_url,
                  encrypted_password: product.creator.encrypted_password,

                },
                product_reference: { 
                  available: product.product_reference&.available
                },
                product_options: product.product_options.map do 
                  |option| { 
                    name: option.name, 
                    quantity_left: option.quantity_left, 
                    description: option.description, 
                    price_difference_cents: option.price_difference_cents, 
                    recurrence_price_values: option.recurrence_price_values,
                    is_pwyw: option.is_pwyw 
                  } 
                end,
                product_attributes: product.product_attributes.map do 
                  |attribute| { 
                    name: attribute.name, 
                    value: attribute.value 
                    } 
                end,
                covers: product.covers.map do |media| 
                  { 
                    url: media.url,
                    original_url: media.original_url,
                    thumbnail: media.thumbnail,
                    external_id: media.external_id,
                    media_type: media.media_type,
                    mediaable_type: media.mediaable_type,
                    filetype: media.filetype,
                    width: media.width,
                    height: media.height,
                    native_width: media.native_width,
                    native_height: media.native_height,
                  }
                end,
              }
            end
          }
        }
      end

      File.write('db/seeds_data.yml', data.to_yaml)
      puts 'Exported category and product data to db/seeds_data.yml'
    end
  end

  namespace :import do
    desc "Import data from seeds.yml with bulk import"
    task seeds: :environment do
      # Load the data from YAML file
      data = YAML.load_file(Rails.root.join('db', 'seeds_data.yml'), permitted_classes: [Symbol, BigDecimal])
  
      categories_to_import = []
      creators_to_import = []
      creators_data = []

      data.each do |entry|
        category_data = entry[:category]
        categories_to_import << Category.new(category_data.except(:products))
        
        entry[:category][:products].each do |product|
          creators_data << product[:creator] unless creators_data.any? { |c| c[:username] == product[:creator][:username] }
        end
      end

      # Bulk import categories and fetch the result to update IDs
      Category.import categories_to_import, recursive: true, on_duplicate_key_ignore: true

      # Prepare creators for import
      creators_to_import = creators_data.map do |creator| 
        creator = Creator.new(creator)
        creator.password = 'password'
        creator
      end
      Creator.import creators_to_import, on_duplicate_key_ignore: true

      # Map of creator username to ID, for assigning to products
      creator_username_to_id = Creator.all.each_with_object({}) { |creator, hash| hash[creator.username] = creator.id }

      # Refetch categories to get them with their IDs
      category_name_to_id = Category.all.each_with_object({}) { |cat, hash| hash[cat.name] = cat.id }

      products_to_import = []
      product_references_to_import = []
      product_options_to_import = []
      product_attributes_to_import = []
      covers_to_import = []

      data.each do |entry|
        category_data = entry[:category]
        category_id = category_name_to_id[category_data[:name]]
  
        entry[:category][:products].each do |product_data|
          creator_id = creator_username_to_id[product_data[:creator][:username]]
          product = Product.new(product_data.except(:creator, :product_reference, :product_options, :product_attributes, :covers))
          product.creator_id = creator_id
          products_to_import << product
  
          # Placeholder for product_id assignment after import
          product_data[:temp_id] = product.object_id
        end
      end

       # Bulk import products to get their IDs
      Product.import products_to_import, on_duplicate_key_ignore: true

      # Counting category stats
      Category.all do |category|
        products = Product.by_category(category.long_slug).published
        product_count = products.count
        creator_count = products.featured.count
        sales_count = products.map(&:sales_count).sum
        
        CategoryStat.create(category_id: category.id, creator_count: creator_count, product_count: product_count, sales_count: sales_count)
      end

      # Mapping temp_id to actual ID for dependent entities
      temp_id_to_product_id = {}
      products_to_import.each { |product| temp_id_to_product_id[product.object_id] = product.id }

  
      data.each do |entry|
        entry[:category][:products].each do |product_data|
          product_id = temp_id_to_product_id[product_data[:temp_id]]
          product_references_to_import << ProductReference.new(product_data[:product_reference].merge(product_id: product_id))
          product_options_to_import.concat(product_data[:product_options].map { |option| ProductOption.new(option.merge(product_id: product_id)) })
          product_attributes_to_import.concat(product_data[:product_attributes].map { |attr| ProductAttribute.new(attr.merge(product_id: product_id)) })
          covers_to_import.concat(product_data[:covers].map { |cover| EmbedMedia.new(cover.merge(mediaable_id: product_id)) })
        end
      end
  
      # Bulk import dependent entities
      ProductReference.import product_references_to_import, on_duplicate_key_ignore: true
      ProductOption.import product_options_to_import, on_duplicate_key_ignore: true
      ProductAttribute.import product_attributes_to_import, on_duplicate_key_ignore: true
      EmbedMedia.import covers_to_import, on_duplicate_key_ignore: true
  
      puts "Import completed successfully."
    end
  end
  
end

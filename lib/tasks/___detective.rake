require Rails.root.join("lib/modules/detective/detective.rb")

namespace :detective do
  desc "Crawl Gumroad"
  task :search, %i[category take] => [:environment] do
    category = ARGV[1]
    take = ARGV[2] || "2"

    if take.to_s == "2"
      category_list = GumroadMeta::Categories.submenu_path_list(category:).sort_by(&:length).reverse
    elsif take.to_s == "1"
      category_list = GumroadMeta::Categories.path_list(skip_root: true).select { |c| c.include?(category.to_s) }
    end

    category_list.each do |c|
      params = "sort=default"
      url = "https://discover.gumroad.com#{c}?#{params}"
      crawl(url:, category: c, overwrite: take.to_s == "1")
    end
  end

  desc "Search all edge subcategories within a main category (skip root)"
  task search_category: [:environment] do
    category_name = ENV.fetch "category", ""
    direct = ENV.fetch "direct", false
    take = ENV.fetch "take", "2"
    filter = ENV.fetch "url", ""

    if category_name == "" && filter == ""
      puts "No category name or direct url provided"
      break
    end

    puts "INVOKED WITH: #{category_name} #{take}"

    category_list =
      if filter == ""
        case take.to_s
        when "2"
          GumroadMeta::Categories.submenu_path_list(category: category_name).sort_by(&:length).reverse
        when "1"
          GumroadMeta::Categories.path_list(category: category_name)
        end
      else
        GumroadMeta::Categories.path_list(skip_root: false)
      end

    print "CATEGORY LIST: #{category_list}\n"
    # category_list.sort_by(&:length).reverse.each { |category| crawl(category: category) }
    # category_list = GumroadMeta::Categories.path_list(category: category_name)
    category_list.select! { |path| path == filter } unless filter.empty?
    category_list.each do |category|
      # sort=featured
      # sort=newest
      # sort=hot_and_new
      # sort=highest_rated
      # sort=most_reviewed
      # sort=price_asc
      # sort=price_desc
      params_list = %w[sort=default]
      # params = "sort=default"
      params_list.each do |params|
        url = "https://discover.gumroad.com#{category}?#{params}"
        crawl(category:, url:, overwrite: (take.to_s == "1"), limit: 10_000, direct_json: direct)
      end
    end
  end

  task check_data: [:environment] do
    filter = ENV.fetch "url", ""
    type = ENV.fetch "type", "all"
    path_list = GumroadMeta::Categories.path_list(skip_root: false, include_names: true)

    incomplete_paths = []
    path_list
      .select { |path| path[:path].include?(filter) }
      .each do |category|
        latest_count = Category.where(meta_url: category[:path]).first.meta_count
        # manual_count = category[:count]
        actual_count =
          Product.where("meta_url LIKE ?", "https://discover.gumroad.com#{category[:path]}%").count

        threshold_percent = 0.1
        prefix = ""
        discrepancy =
          (latest_count - actual_count).abs.to_f.fdiv(latest_count.nonzero? ? latest_count : 1)
        if discrepancy >= threshold_percent
          incomplete_paths << category[:path]
          prefix += "[!]"
        end
        prefix += "[r]" if category[:is_root]
        case type
        when "all"
          puts "#{prefix} \t #{category[:path]}: #{actual_count} of #{latest_count} (#{(1 - discrepancy).*(100).round(2)}%)"
        when "incomplete"
          puts "#{prefix} \t #{category[:path]}: #{actual_count} of #{latest_count} (#{(1 - discrepancy).*(100).round(2)}%)" if discrepancy >= threshold_percent
        end
      end
  end

  task meta_lookup: [:environment] do
    # condition = ->(p) { p.meta_script == "__blank__" || p.meta_script.nil? || p.meta_script == "" }

    total_count = Product.count
    # products = Product.where(meta_script: ["__blank__", nil, ""])
    products = Product.all

    crawler = Detective::Detective.new("", true)
    products.each_with_index do |product, index|
      puts "#{index + 1} / #{products.count} / #{total_count}"
      p = Product.where(url: product.url).first
      # next unless condition.call(p)
      puts "LOOKING UP: #{product.url}"
      meta_script = crawler.get_more_info_static(product.url)
      if meta_script
        if meta_script == product.meta_script 
          puts "Same meta!"
        else
          puts "Updated meta: #{product.url}"
          p.meta_script = meta_script
        end
      else
        puts "Updated meta: #{product.url}"
        p.available = false
      end
      p.save
      sleep(Random.rand(0.01..0.05))
    end
    crawler.quit
  end

  private

  def crawl(**args)
    url = args.fetch :url, nil
    category = args.fetch :category, ""
    params = args.fetch :params, "sort=default"
    overwrite = args.fetch :overwrite, false

    # hotfix
    category = category.sub!('crafts-and-diy', 'crafts-and-dyi') 
    url = url.sub!('crafts-and-diy', 'crafts-and-dyi') 

    url ||= "https://discover.gumroad.com#{ncategory}?#{params}"
    if args.fetch(:direct_json, false)
      c = category
      c[0] = "" if c[0] == "/"
      url =
        "https://discover.gumroad.com/products/search?taxonomy=#{c.split("/").join("%2F")}&#{params}}"
    end

    detective = Detective::Detective.new(url)
    limit_index = 0
    detective.run(
      category: category,
      params:,
      testrun: false,
      direct_json: args.fetch(:direct_json, false),
      delay_range: [1.15, 1.75]
    ) do |product_data|
      limit_index += 1
      break if limit_index > args.fetch(:limit, 10_000)
      puts "CATEGORY: #{category}"
      product = Product.where(url: product_data[:url]).first
      if product.present?
        puts "Product with this URL already exists:\n ID (existing) #{product.id}; URL (existing): #{product.url}\n META (existing): #{product.meta_url}\n#"
        puts "Checking product name..."
        puts "Product name: #{product.name}\nExpected name: #{product_data[:name]}\n#"
        puts "Same?: #{product.name == product_data[:name]}"

        if overwrite
          product.update(product_data)
          puts "UPDATED"
        else
          puts "SKIPPED"
        end
      else
        Product.create(product_data)
        puts "SAVED\n"
      end
      print "------\n\n"
    end
  end
end

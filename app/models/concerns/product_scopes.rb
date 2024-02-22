module ProductScopes
  include ProductConstants
  extend ActiveSupport::Concern

  included do
    # === Internal filters === #

    # Publication status
    scope :published, -> { where(published: true) }

    # Availability status (external url check)
    scope :available, -> (available=true) { includes(:product_reference).where(product_reference: {available: available}) }

    # Pay What You Want status
    scope :pwyw, -> { where(is_pwyw: true) }

    # Showcase status
    scope :showcase, -> { where(is_weekly_scowcase: true) }

    # === Search scopes === #

    # Textual filters
    scope :by_name, ->(name) { where(arel_table[:name].matches("%#{sanitize_sql_like(name)}%")) }
    scope :by_query, ->(query) {
      joins(:creator).where(
        arel_table[:name].matches("%#{sanitize_sql_like(query)}%")
        .or(Creator.arel_table[:name].matches("%#{sanitize_sql_like(query)}%"))
      )
    }
    scope :by_category, ->(long_slug){ where(arel_table[:category_slugs].contains([long_slug])) }

    # Custom finder
    scope :by_username, ->(username) { joins(:creator).where(creators: { username: username.to_s }) }
    scope :by_permalink, ->(permalink) { { permalink: permalink } }

    # Tag filters
    # ---
    # Select products that are tagged by all of the given tags (can also be tagged by other tags)
    scope :by_tags, ->(*tags) {
      return all if tags.blank?

      tags = tags.flatten.map(&:downcase).uniq
      tagged_products_sql = ActsAsTaggableOn::Tagging.joins(:tag)
        .where('lower(tags.name) IN (?)', tags)
        .where(context: 'tags')
        .select(:taggable_id)
        .group(:taggable_id)
        .having('COUNT(taggable_id) >= ?', tags.size)
        .to_sql

      where("id IN (#{tagged_products_sql})")
    }
    scope :by_any_tags, ->(tags=[]) { tagged_with(tags, any: true, parse: true) }
    scope :by_all_tags, ->(tags=[]) { tagged_with(tags, match_all: true, parse: true) }

    # Numeric filters
    scope :by_min_rating, ->(rating) { where(arel_table[:rating].gteq(rating.to_f)) }
    scope :by_min_price, ->(min) {
      min ? where(arel_table[:price_cents].gteq([min.to_i, MIN_SEARCHABLE_PRICE_CENT].max)) : all
    }

    scope :by_max_price, ->(max) {
      max ? where(arel_table[:price_cents].lteq([max.to_i, MAX_SEARCHABLE_PRICE_CENT].min)) : all
    }

    # Sorting
    scope :sorted_by, ->(option) { 
      option ? sort_by_option(option.to_sym) : all
    }
    scope :hot_and_new, ->{ sorted_by(:hot_and_new) }
    scope :newest, -> { sorted_by(:newest) }
    scope :highest_rated, -> { sorted_by(:highest_rated) }
    scope :most_reviewed, -> { sorted_by(:most_reviewed) }
    scope :price_asc, -> { sorted_by(:price_asc) }
    scope :price_desc, -> { sorted_by(:price_desc) }

    # Discover
    scope :staff_picks, ->{ 
      order(rating: :desc, rating_counts_total: :desc, created_at: :desc)
    }
    scope :best_selling, ->{ 
      order(sales_count: :desc, rating_counts_total: :desc, created_at: :desc) 
    }
    scope :featured, ->{ 
      # Select the best selling product for each creator. Equiavalent to:
      # ---
      # SELECT products.* FROM products
      # INNER JOIN
      #   (SELECT DISTINCT ON (creator_id) id FROM products
      #    ORDER BY products.creator_id, products.sales_count DESC,
      #    products.rating DESC, products.created_at DESC) best_selling_products
      #   ON best_selling_products.id = products.id
      # ORDER BY best_selling_products.sales_count
      # ---
      products = Product.arel_table
      best_selling_products = Product.arel_table.alias('best_selling_products')
      subquery = products
        .project(products[:id])
        .distinct_on(products[:creator_id])
        .order(products[:creator_id], products[:sales_count].desc, products[:rating_counts_total].desc, products[:created_at].desc)
      join = products.create_join(
        subquery.as(best_selling_products.name),
        products.create_on(products[:id].eq(best_selling_products[:id]))
      )
      joins(join).order(products[:sales_count].desc)
    }
  end

  class_methods do
    def sort_by_option(option)
      case option
      when :featured then order(sales_count: :desc, rating_counts_total: :desc, created_at: :desc)
      when :newest then order(created_at: :desc)
      when :hot_and_new then order(rating_counts_total: :desc, created_at: :desc)
      when :highest_rated then order(rating: :desc)
      when :most_reviewed then order(rating_counts_total: :desc)
      when :price_asc then order(price_cents: :asc)
      when :price_desc then order(price_cents: :desc)
      when :default then send(__method__, :featured)
      else all
      end
    end

    def find_by_username_and_permalink(username, permalink)
      includes(:creator).where(creators: { username: username }).find_by(permalink: permalink)
    end
  end
end
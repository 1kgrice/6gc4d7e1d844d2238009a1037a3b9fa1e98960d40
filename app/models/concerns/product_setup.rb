module ProductSetup
  def take_attributes_from_meta!
    default_rating = [0,0,0,0,0]
    update!(rating_counts: meta.rating_counts || default_rating, price_cents: meta.price_cents)
  end

  def categorize!
    return unless meta&.meta_url.present?
    uri = URI.parse(meta.meta_url)    
    original_long_slug = uri.path[1..] 
    slugs = uri.path.split('/').reject(&:empty?)
    categories = slugs.map.with_index { |_, i| slugs[0..i].join('/') }
    update(category_slugs: categories)
  end
end
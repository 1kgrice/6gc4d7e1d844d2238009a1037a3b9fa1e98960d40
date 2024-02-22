class TagRebuildWorker
  include Sidekiq::Worker

  def perform(product_ids)
    products = Product.where(id: product_ids).includes(:tags)
  
    new_taggings = []
    tag_names = Set.new

    products.each do |product|
      product.meta_tags.each do |tag_name|
        tag_names.add(tag_name)
      end
    end

    existing_tags = ActsAsTaggableOn::Tag.where(name: tag_names.to_a)
    tags_to_create = tag_names - existing_tags.pluck(:name)
    new_tags = tags_to_create.map { |name| ActsAsTaggableOn::Tag.new(name: name) }
    ActsAsTaggableOn::Tag.import(new_tags)
    all_tags = ActsAsTaggableOn::Tag.where(name: tag_names.to_a).index_by(&:name)

    products.find_each(batch_size: 1000) do |product|
      product.meta_tags.each do |tag_name|
        tag = all_tags[tag_name]
        next unless tag

        new_taggings << ActsAsTaggableOn::Tagging.new(taggable_id: product.id, taggable_type: 'Product', tag_id: tag.id, context: 'tags')
      end
    end

    ActsAsTaggableOn::Tagging.import(new_taggings)
    puts "Rebuilt tags and taggings for #{products.size} products."
  end
end

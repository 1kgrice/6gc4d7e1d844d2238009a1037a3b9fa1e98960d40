ActsAsTaggableOn.force_lowercase = true

module ActsAsTaggableOnExtension
  extend ActiveSupport::Concern

  class_methods do
    # Returns the top tags for a given collection of taggable objects

    def top_tags_for(collection, klass, limit: DEFAULT_LIMIT[:tags])
      # Keep some SQL syntax here for simplicity as Arel does not directly support aliasing
      taggable_ids = collection.ids

      taggings_count_subquery = ActsAsTaggableOn::Tagging
                            .select('tag_id, COUNT(tag_id) AS count')
                            .where(taggable_type: klass.to_s, taggable_id: taggable_ids)
                            .group(:tag_id)
                            .to_sql

     top_tags = ActsAsTaggableOn::Tag
             .select('tags.*, taggings_count.count as dynamic_taggings_count')
             .from("(#{taggings_count_subquery}) AS taggings_count")
             .joins('JOIN tags ON tags.id = taggings_count.tag_id')
             .order('dynamic_taggings_count DESC')
             .limit(limit)

      top_tags = top_tags.load

      # top_tags =  if top_tags.empty?

      top_tags.map do |tag|
        ActsAsTaggableOn::Tag.new({
          id: tag[:id],
          name: tag[:name],
          taggings_count: tag[:dynamic_taggings_count]
        })
      end
    end
  end
end

ActsAsTaggableOn::Tag.include ActsAsTaggableOnExtension
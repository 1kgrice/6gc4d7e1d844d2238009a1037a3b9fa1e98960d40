module ActsAsTaggableOnExtension
  extend ActiveSupport::Concern

  class_methods do
    def top_tags_for(collection, class_name, limit: 10)
      tags_table = ActsAsTaggableOn::Tag.arel_table
      taggings_table = ActsAsTaggableOn::Tagging.arel_table

      subquery = taggings_table
        .where(taggings_table[:taggable_type].eq(class_name))
        .where(taggings_table[:taggable_id].in(collection.select(:id)))
        .project(taggings_table[:tag_id])
        .group(taggings_table[:tag_id])
        .as('taggings_count')

      # Use a raw SQL snippet for the COUNT() function and aliasing, as Arel does not support these directly
      select_statement = tags_table.project(tags_table[Arel.star], Arel.sql('COUNT(taggings.tag_id) AS tgs_count'))

      top_tags_query = tags_table
        .join(subquery, Arel::Nodes::OuterJoin)
        .on(tags_table[:id].eq(subquery[:tag_id]))
        .from([tags_table, subquery])
        .group(tags_table[:id])
        .order(Arel.sql('tgs_count DESC'))
        .take(limit)

      top_tags = ActsAsTaggableOn::Tag.find_by_sql(top_tags_query.to_sql)
    end
  end

end

ActsAsTaggableOn::Tag.include ActsAsTaggableOnExtension
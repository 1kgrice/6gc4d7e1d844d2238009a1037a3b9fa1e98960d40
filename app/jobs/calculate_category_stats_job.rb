class CalculateCategoryStatsJob < ApplicationJob
  queue_as :default

  def perform
    Category.all do |category|
      products = Product.by_category(category.long_slug).published
      product_count = products.count
      creator_count = products.featured.count
      sales_count = products.map(&:sales_count).sum
      
      stat = category.stat || CategoryStat.create(category: category)
      stat.update(creator_count: creator_count, product_count: product_count, sales_count: sales_count)
    end
  end
end
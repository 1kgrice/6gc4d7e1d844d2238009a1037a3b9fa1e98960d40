class CalculateCategoryStatsJob < ApplicationJob
  queue_as :default

  def perform
    Category.find_each do |category|
      print "Calculating stats for #{category.long_slug}..."
      products = Product.by_category(category.long_slug).published
      product_count = products.count
      creator_count = products.featured.count
      sales_count = products.map(&:sales_count).sum
      
      stats = category.stats || CategoryStat.create(category: category)
      stats.update(creator_count: creator_count, product_count: product_count, sales_count: sales_count)
    end
  end
end
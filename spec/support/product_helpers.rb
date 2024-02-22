module ProductHelpers
  def sorted_product_ids(sort_option)
    Product.sort_by_option(sort_option).pluck(:id)
  end
end
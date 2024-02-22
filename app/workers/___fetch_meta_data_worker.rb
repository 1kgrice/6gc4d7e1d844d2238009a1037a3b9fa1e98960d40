require Rails.root.join("lib/modules/detective/detective.rb")

class FetchMetaDataWorker
  include Sidekiq::Worker
  # Sidekiq_options queue: "default"

  def perform(product_id)
    product = Product.find(product_id)
    if product.present?
      meta_script = Detective::Detective.new("", true).get_more_info_static(product.url)
      if meta_script
        product.meta_script = meta_script
        product.avaliable = true
      else
        product.available = false
      end
      product.save
    end
  end
end

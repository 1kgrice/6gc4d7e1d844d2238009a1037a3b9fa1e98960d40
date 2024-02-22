# Sidekiq Job to process meta data for a product
class ProcessMetaDataWorker
  include Sidekiq::Worker

  def perform(product_id)
    product = Product.find(product_id)
    product.process_meta_data! if product.present?
  end
end

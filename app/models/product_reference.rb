class ProductReference < ApplicationRecord
  # Container for web scraped data, used as a reference for real product content.

  include Scrapable
  belongs_to :product
  scope :available, -> { where(available: true) }
  before_destroy :prevent_destroy
  
  private
  def prevent_destroy
    throw(:abort)
  end
end

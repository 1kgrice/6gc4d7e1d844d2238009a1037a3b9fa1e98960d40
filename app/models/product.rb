# frozen_string_literal: true

class Product < ApplicationRecord
  include ProductConstants  
  include ProductSetup
  include ProductScopes
  include ProductCallbacks
  include Taggable
  include Ratable

  # Associations
  belongs_to :creator, optional: true
  has_and_belongs_to_many :categories
  has_one :product_reference, class_name: "ProductReference", dependent: :nullify
  has_many :product_attributes, class_name: "ProductAttribute", dependent: :destroy
  has_many :product_options, dependent: :destroy
  has_many :covers, -> { where(mediaable_type: 'Product') }, class_name: 'EmbedMedia', foreign_key: 'mediaable_id', dependent: :destroy
  has_many :tags, through: :taggings, after_add: :add_to_meta_tags, after_remove: :remove_from_meta_tags

  # Aliases
  alias meta product_reference
  alias meta= product_reference=

  # Validations
  validates :name, presence: true, length: { maximum: MAX_NAME_LENGTH }
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }, allow_nil: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: MAX_SEARCHABLE_PRICE_CENT }, allow_nil: true
  validates :permalink, format: { with: PERMALINK_REGEX, message: "can only contain alphanumeric characters, dashes, or underscores" }
  validates :currency_code, inclusion: { in: CURRENCY_CODES, message: "%<value>s is not a valid currency" }
  

  def full_url
    "#{creator.profile_url}/l/#{permalink}"
  end

  def select_new_main_cover(removed_cover = nil, removing: false)
    return if covers.empty? || (covers.size == 1 && removing)
    new_main_cover = if removing
      covers.where.not(id: removed_cover.id).first
    else
      covers.order(:created_at).first
    end
    update(main_cover_id: new_main_cover&.external_id)
  end

  def update_category_slugs!
    update(category_slugs: categories.pluck(:long_slug))
  end

  class << self
    def update_category_slugs!(product_ids)
      Product.find(product_ids).each(&:update_category_slugs!)
    end
  end

  def add_to_meta_tags(tag)
    current_tags = meta_tags || []
    updated_tags = current_tags.append(tag.name).uniq
    update_columns(meta_tags: updated_tags)
  end

  def remove_from_meta_tags(tag)
    return unless meta_tags
    updated_tags = meta_tags.reject { |tag_name| tag_name == tag.name }
    update_columns(meta_tags: updated_tags)
  end
end
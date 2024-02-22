class Category < ApplicationRecord
  include Inheritable

  # Associations
  has_and_belongs_to_many :products
  has_one :stats, class_name: "CategoryStat", foreign_key: :category_id, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :meta_url, allow_blank: true }
  validates :slug, uniqueness: { case_sensitive: false, allow_blank: true }
  validates :long_slug, uniqueness: { case_sensitive: false, allow_blank: true }

  # Callbacks
  after_save :assign_slugs, if: :saved_change_to_name?
  after_update :update_product_associations, if: -> { long_slug_changed? }
  
  # Scopes
  scope :with_stats, -> { includes(:stats) }
  scope :root, -> (root=true){ where(is_root: root) }
  scope :by_slug, ->(slug) { where(slug: CGI::unescape(slug)) }
  scope :by_long_slug, ->(long_slug) { where(long_slug: CGI::unescape(long_slug)) }
  scope :by_parent_id, ->(parent_id) { where(parent_id: parent_id) }
  scope :by_name, ->(name) { where("lower(name) = ?", name.downcase) }
  scope :by_parent_slug, ->(slug) { includes(:parent).where(parents_categories: { slug: slug }) }
  scope :by_parent_long_slug, ->(long_slug) { includes(:parent).where(parents_categories: { long_slug: long_slug }) }
  scope :published, -> { where(published: true) }

  def category_tree
    {
      id: id,
      name: name,
      slug: slug,
      meta_url: meta_url,
      meta_count: meta_count,
      parent_id: parent_id,
      children: children.map(&:category_tree)
    }
  end

  def assign_slugs
    self.slug = generate_slug
    self.long_slug = generate_long_slug
    save
  end

  def generate_slug(str = name)
    str.downcase.gsub("&", "and").gsub(%r{[/',]}, "").split.join('-')
  end

  def generate_long_slug
    return slug unless parent_id
    ancestors.map(&:slug).join("/") + "/" + slug
  end

  def regenerate_slugs!
    update(slug: generate_slug, long_slug: generate_long_slug)
  end

  class << self
    def regenerate_all_slugs!
      find_each(batch_size: 100, &:regenerate_slugs!)
    end
  end

  private 
  
  def update_product_associations
    product_ids = products.pluck(:id)
    UniversalWorker.perform_async("Product", "update_category_slugs!", {}, { "product_ids" => product_ids })
  end
end
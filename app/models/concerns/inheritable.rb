
module Inheritable
  extend ActiveSupport::Concern
  include AppErrors

  included do
    raise AppErrors::Inheritable::InterfaceNotImplementedError, 'Model must define is_root and is_nested methods' unless column_names.map(&:to_sym).include?(:is_root) && column_names.map(&:to_sym).include?(:is_nested)

    after_touch :check_nested_status

    belongs_to :parent, class_name: to_s, optional: true, touch: true, foreign_key: :parent_id
    has_many :children, class_name: to_s, foreign_key: :parent_id

    scope :by_parent_id, ->(id) { where(parent_id: id) }
    scope :root, ->(root=true) { where(is_root: root) }
    scope :nested, ->(nested=true) { where(is_nested: nested) }

    def has_parent?
      parent_id.present?
    end

    def has_children?
      children.any?
    end 

    def ancestors 
      return [] unless has_parent?
      parent.ancestors + [parent]    
    end

    def all_children
      children.flat_map do |child|
        [child] + child.all_children
      end
    end

    def self.find_by_ancestor_id(id)
      find(id).all_children
    end

    def check_nested_status
      update(is_nested: has_children?)
      parent.touch if has_parent?
    end
  end
end
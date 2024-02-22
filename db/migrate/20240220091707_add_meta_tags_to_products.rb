class AddMetaTagsToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :meta_tags, :string, array: true, default: []
  end
end

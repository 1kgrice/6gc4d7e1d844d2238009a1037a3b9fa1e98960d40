class AddMetaUrlToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :meta_url, :string
  end
end

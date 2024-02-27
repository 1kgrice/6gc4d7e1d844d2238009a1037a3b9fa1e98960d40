class FixProductColumnTypesForImages < ActiveRecord::Migration[7.0]
  def change
    change_column :products, :user_avatar, :string, array: false, default: ''

    remove_column :products, :images
    add_column :products, :images, :string, array: true, default: []
  end
end

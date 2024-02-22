class RefactorTableProducts < ActiveRecord::Migration[7.0]
  def change
    rename_column :products, :g_user_url, :user_url
    rename_column :products, :g_user_name, :user_name
    rename_column :products, :g_user_avatar, :user_avatar
    rename_column :products, :image, :images
  end
end

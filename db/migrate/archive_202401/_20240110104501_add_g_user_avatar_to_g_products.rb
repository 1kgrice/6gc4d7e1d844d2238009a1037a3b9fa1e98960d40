class AddGUserAvatarToGProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :g_products, :g_user_avatar, :string, array: true, default: []
  end
end

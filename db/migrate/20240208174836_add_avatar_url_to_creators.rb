class AddAvatarUrlToCreators < ActiveRecord::Migration[7.1]
  def change
    add_column :creators, :avatar_url, :string
  end
end

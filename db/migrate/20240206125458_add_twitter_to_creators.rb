class AddTwitterToCreators < ActiveRecord::Migration[7.1]
  def change
    add_column :creators, :twitter, :string
  end
end

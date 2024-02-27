class AddNsfwToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :nsfw, :boolean, default: false
  end
end

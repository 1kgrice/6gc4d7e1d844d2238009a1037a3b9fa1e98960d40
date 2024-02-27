class AddPublishedToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :published, :boolean, default: false
  end
end

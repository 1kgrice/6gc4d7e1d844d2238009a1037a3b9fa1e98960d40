class AddDescriptionHtmlToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :description_html, :text
  end
end

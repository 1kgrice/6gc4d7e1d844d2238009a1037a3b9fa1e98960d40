class AddCustomButtonOptionsToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :custom_view_content_button_text, :string
    add_column :products, :custom_button_text_option, :string
  end
end

class AddMetaScriptToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :meta_script, :text
  end
end

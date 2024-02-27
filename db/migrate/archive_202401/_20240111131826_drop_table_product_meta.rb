class DropTableProductMeta < ActiveRecord::Migration[7.0]
  def change
    drop_table :product_meta
  end
end

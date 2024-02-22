class CreateProductMeta < ActiveRecord::Migration[7.0]
  def change
    create_table :product_meta do |t|
      t.references :product, null: false, foreign_key: true
      t.text :script

      t.timestamps
    end
  end
end

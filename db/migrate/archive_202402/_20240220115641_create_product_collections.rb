class CreateProductCollections < ActiveRecord::Migration[7.1]
  def change
    create_table :product_collections do |t|
      t.string :name
      t.string :slug, index: { unique: true }
      t.timestamps
    end
  end
end

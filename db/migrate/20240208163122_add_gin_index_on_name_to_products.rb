class AddGinIndexOnNameToProducts < ActiveRecord::Migration[7.1]
  def up
    # Adds a GIN index using the pg_trgm operator on the 'name' column of 'products'
    execute <<-SQL
      CREATE INDEX index_products_on_name_trgm ON products USING gin (name gin_trgm_ops);
    SQL
  end

  def down
    remove_index :products, name: :index_products_on_name_trgm
  end
end
